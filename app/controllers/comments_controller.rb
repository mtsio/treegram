class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end

  def create
    @user = User.find(params[:comment][:user_id])
    @photo = Photo.find(params[:comment][:photo_id])
    @comment = Comment.create({user_id: params[:comment][:user_id], photo_id: params[:comment][:photo_id], content: params[:comment][:content]})
    flash[:notice]="User #{@user.email} added comment for photo #{@photo.title} at #{@comment.created_at}"
    redirect_to user_path(session[:user_id])
  end
end
