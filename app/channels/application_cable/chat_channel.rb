module ApplicationCable
  class ChatChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "chat_#{params[:room]}"
      puts 'YEAH'
    end

    def receive(data)
      ActionCable.server.broadcast("chat_#{params[:room]}", data)
    end
  end
end
