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
end