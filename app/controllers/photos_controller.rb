class PhotosController < ApplicationController
  def index
    @photos = Photo.find(:all)
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @photos }
    end
  end
  
  def show
    @photo = Photo.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @photo }
    end
  end
end