# frozen_string_literal: true

# Controller for handling quest-related actions.
class QuestsController < ApplicationController
  before_action :authenticate_user

  def authenticate_user
    @cur_user = User.find_user_by_session_token(cookies[:session])
    return if @cur_user

    flash[:alert] = 'Please login'
    redirect_to users_login_path
  end

  def complete
    quest = Quest.find(params[:id])
    quest.complete
    redirect_to world_path(quest.world)
  end

  def complete_trivia
    quest = Quest.find(params[:id])
    if quest.complete_trivia(params[:answer])
      flash[:notice] = 'Correct answer! Quest completed.'
    else
      flash[:alert] = 'Incorrect answer.'
    end
    redirect_to world_path(quest.world)
  end

  def show
    @quest = Quest.find(params[:id])
  end

  def quest
    @cur_user = User.find_user_by_session_token(cookies[:session])
    @user_world = UserWorld.find_by_ids(@cur_user.id, params[:world_id])

    generate if @user_world.quests.where(completed: false).empty?

    @quest = @user_world.quests.where(completed: false).first
    @quests = @user_world.quests

    if @quest&.move_quest?
      @random_quest_message = Quest.random_quest_message(@quest)
      puts "random: " + @random_quest_message
    end

    respond_to do |format|
      format.js
    end
  end

  def generate
    world = World.find(params[:world_id])

    begin
      world.generate_quest_for(User.find_user_by_session_token(cookies[:session]))
      flash[:notice] = 'Quest generated.'
    rescue Quest::NoFilledCellsError => e
      flash[:alert] = e.message
    end
    
  end
end
