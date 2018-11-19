class PhotosController < ApplicationController
  def create
    @user = User.find(params[:user_id])

    logger.debug "parmas hash: #{params}"
    if params[:photo][:image] == nil
      flash[:alert] = "Please upload a photo"
      redirect_to :back
    elsif params[:photo][:title].blank?
      flash[:alert] = "Please specify a title"
      redirect_to :back
    else
      @photo = Photo.create(photo_params)
      @photo.user_id = @user.id
      @photo.save
      flash[:notice] = "Successfully uploaded a photo"
      redirect_to user_path(@user)
    end
  end

  def new
    @user = User.find(params[:user_id])
    @photo = Photo.create()
  end
  
  private
  def photo_params
    params.require(:photo).permit(:image, :title, :text)
  end
end
