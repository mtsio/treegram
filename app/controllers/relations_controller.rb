class RelationsController < ApplicationController
  def index
    @user = User.find(session[:user_id])
  end

  def new
    self.create
  end

  def create
    @follower = User.find(session[:user_id])
    @followingID = params[:user_id]
    @relation = @follower.relations.create
    @relation.follower = @follower.id
    @relation.following = @followingID
    @followingUser = User.find(@followingID)
    if @relation.save
      flash[:notice]= "You start following #{@followingUser.email}"
      redirect_to users_path
    end
  end

  private
  def relation_params
      params.permit(:user_id, :following, :follower)
  end

end
