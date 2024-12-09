class QuestsController < ApplicationController
  def complete
    quest = Quest.find(params[:id])
    quest.complete
    redirect_to world_path(quest.world)
  end

  def complete_trivia
    quest = Quest.find(params[:id])
    if quest.complete_trivia(params[:answer])
      flash[:notice] = "Correct answer! Quest completed."
    else
      flash[:alert] = "Incorrect answer."
    end
    redirect_to world_path(quest.world)
  end

  def show
    @quest = Quest.find(params[:id])
  end

  def generate
    world = World.find(params[:world_id])
    world.generate_quest_for(User.find_user_by_session_token(cookies[:session]))
    redirect_to world_path(world)
  end
end