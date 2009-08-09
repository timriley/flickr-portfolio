class PhotosController < ApplicationController
  def show
    # Find the photo from id or get the most recent one.
    @photo = params[:id] ? Photo.find_by_flickr_id(params[:id].to_i) : Photo.latest
    
    respond_to do |format|
      format.html
    end
  end
end