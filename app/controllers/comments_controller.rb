class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end

  def create
    @user = User.find(params[:comment][:user_id])
    @photo = Photo.find(params[:comment][:photo_id])
    @comment = Comment.create({user_id: params[:comment][:user_id],
                               photo_id: params[:comment][:photo_id],
                               content: params[:comment][:content]}) unless
      params[:comment][:content].blank?
    
    if params[:comment][:content].blank?
      flash[:alert]="Empty Comment"
    elsif
      flash[:notice]="User #{@user.email} added comment for photo \
                           #{@photo.title} at #{@comment.created_at}"
    end
    redirect_to user_path(session[:user_id])
  end

  private
  def comment_params
    params.require([:comment][:content])
  end
end
