class UsersController < ApplicationController

  def new
    flash[:alert] = "The username sally already exists"
  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def des

  end

  def login
    flash[:alert] = "Wrong username and password combination"
  end

  def get_session
  
  end

  def logout

  end
end