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
      flash[:alert] = "Incorrect answer. Try again."
    end
    redirect_to world_path(quest.world)
  end

  def show
    @quest = Quest.find(params[:id])
  end

  def generate
    user_id = User.find_user_by_session_token(cookies[:session]).id
    world_id = params[:world_id]

    user_world = UserWorld.find_by(user_id: user_id, world_id: world_id)
    if user_world
      if rand(2).zero?
        Quest.generate_movement_for(user_world)
        Rails.logger.info("Generated movement quest")
      else
        Quest.generate_trivia_for(user_world)
        Rails.logger.info("Generated trivia quest")
      end
      flash[:notice] = "New quest generated!"
    else
      flash[:alert] = "No existing quest to generate a new one."
    end
    redirect_to world_path(world_id)
  end
end