# frozen_string_literal: true

# Controller for handling quest-related actions.
class QuestsController < ApplicationController
  before_action :authenticate_user
  protect_from_forgery except: :quest

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    redirect_to users_login_path
  end

  def complete
    quest = Quest.find(params[:id])
    if quest.completed
      flash[:notice] = 'Quest completed.'
    else
      flash[:alert] = 'Quest not completed.'
    end

    redirect_to world_path(quest.world)
  end

  def complete_trivia
    quest = Quest.find(params[:id])
    flash[:alert] = if quest.complete_trivia(params[:answer])
                      'Correct answer! Quest completed.'
                    else
                      'Incorrect answer.'
                    end
    redirect_to world_path(quest.world)
  end

  # rubocop:disable Metrics/MethodLength
  def quest
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @user_world = UserWorld.find_by_ids(@cur_user.id, params[:world_id])

    generate_quest(@user_world) if @user_world.quests.where(completed: false).empty?

    @quest = @user_world.quests.where(completed: false).first
    @quests = @user_world.quests

    @random_quest_message = Quest.random_quest_message(@quest) if @quest&.move_quest?

    respond_to do |format|
      format.html do
        render partial: 'quests/quest', locals: { quests: @quests, random_quest_message: @random_quest_message }
      end
      format.js
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def generate_quest(user_world)
    world = user_world.world

    begin
      world.generate_quest_for(User.find_user_by_session_token(cookies[:session]))
      flash[:notice] = 'Quest generated.'
    rescue Quest::NoFilledCellsError => e
      flash[:alert] = e.message
    end
  end
end
