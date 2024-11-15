class WorldsController < ApplicationController
  def world_params
    params.permit(:world_code, :world_name, :user_id, :is_public, :max_player)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @world = World.find(id)
  end

  def index
    @public_worlds = World.where(is_public: true)
    @private_worlds = World.where(is_public: false)
  end

  def new
    # default: render 'new' template
  end

  def create
    @world = World.create!(world_params)
    flash[:notice] = "World was successfully created."
    redirect_to worlds_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def join_world
    @selected_world = params[:id]
    redirect_to world_path(@selected_world.split("_")[1])
  end

  def add_world
    @world = World.create!(world_params)
    redirect_to worlds_path
  end
end