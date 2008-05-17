class PhotosController < ApplicationController
  def show
    # Find the photo from id, or get the most recent one.
    @photo = params[:id] ? Photo.find(params[:id]) : Photo.find(:first, :order => 'created_at DESC')
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @photo }
    end
  end
end