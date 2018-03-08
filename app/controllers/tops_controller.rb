class TopsController < ApplicationController
  def index
    @pictures = Picture.order('emotional_point DESC')
  end
end
