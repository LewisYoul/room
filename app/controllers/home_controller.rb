class HomeController < ApplicationController
  def index
    @messages = Space.first&.messages || []
  end
end
