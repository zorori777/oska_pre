require "net/http"
require "json"

class PostsController < ApplicationController
  def new
    @post = Picture.new
    @pic = Picture.last
  end

  def create
    @post = Picture.create!(set_picture_params)
    uri = URI('https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect')
    uri.query = URI.encode_www_form({
        'returnFaceId' => 'true',
        'returnFaceLandmarks' => 'false',
        'returnFaceAttributes' => 'emotion',
    })

   image_url = @post.image.to_s
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = ENV["FACE_API"]
    request.body = %({\"url\":\"#{image_url}"\})
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == "https") do |http|
        http.request(request)
    end
    face_data = JSON.load(response.body)
    face_number = face_data.length
    if face_number == 0
      @post.update(emotional_point: 0)
    elsif face_number >= 1
      result = face_data.sum {|data| data["faceAttributes"]["emotion"]["happiness"]} / face_number
      @post.update(emotional_point: result)
    end
  end

  private
  def set_picture_params
    params.require(:picture).permit(:image)
  end
end
