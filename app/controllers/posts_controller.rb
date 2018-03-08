class PostsController < ApplicationController
  def new
    @post = Picture.new
    @pic = Picture.last
  end

  def create
    @post = Picture.new(set_picture_params)
    @post.save!
  end

  private
  def set_picture_params
    params.require(:picture).permit(:image)
  end
end
