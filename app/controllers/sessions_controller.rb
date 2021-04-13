# frozen_string_literal: true
class SessionsController < ApplicationController
  skip_before_action :has_info
  skip_before_action :authenticated, only: [:new, :create]

  def new
    @url = params[:url]
    redirect_to home_dashboard_index_path if current_user
  end

  def create
    begin
      user = User.authenticate(params[:email].to_s.downcase, params[:password])
    rescue RuntimeError => e
    end

    if user
      session[:user_id] = user.id if User.where(id: user.id).exists?
      redirect_to home_dashboard_index_path
    else
      flash[:error] = "Either your username and password is incorrect" #e.message
      render "sessions/new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    reset_session
    redirect_to root_path
  end
end
