class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def create
    @user = User.new(user_params)
    @user.valid?
    if !@user.is_email?
      flash[:alert] = "Input a properly formatted email."
      redirect_to :back
    elsif @user.errors.messages[:email] != nil
      flash[:notice]= "That email " + @user.errors.messages[:email].first
      redirect_to :back
    elsif @user.save
      flash[:notice]= "Signup successful. Welcome to the site!"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:alert] = "There was a problem creating your account. Please try again."
      redirect_to :back
    end
  end

  def new
  end

  def show
    @users = User.all
    @user = User.find(params[:id])
    @followingUsers = @user.relations.all

    @photosRes = Array.new
    @photosRes << @user.photos
          .flat_map {|p| {:email => @user.email, :photo => p}}
    @photosRes << @followingUsers
          .map{ |u| User.find(u.following)}
          .flat_map{ |u| u.photos.map{|p| {:email => u.email, :photo => p}}}
    @photosRes = @photosRes.flatten.sort {|a,b| b[:photo].created_at \
                                          <=> a[:photo].created_at}
                   .group_by{ |a| a[:photo].user_id }

    logger.debug "parmas hash: #{@followingUsers.count}"
    @tag = Tag.new
    @comment = Comment.new
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :avatar)
  end


end
