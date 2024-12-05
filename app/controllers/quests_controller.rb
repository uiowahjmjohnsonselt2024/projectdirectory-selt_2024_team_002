class QuestsController < ApplicationController
    def complete
        quest = Quest.find(params[:id])
        quest.complete
        redirect_to world_path(quest.world)
    end
end