# frozen_string_literal: true

# the generic controler for our application. Used to prevent crsf attatcks
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
