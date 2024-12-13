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
    
    redirect_to world_path(world)
  end
end
