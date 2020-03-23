class HomeController < ApplicationController
  def index
    @space = Space.first
  end
end
