module ApplicationCable
  class ChatChannel < ActionCable::Channel::Base
    def subscribed
      space = Space.find_or_create_by(name: params[:room])
      stream_from "chat_#{params[:room]}"
    end

    def receive(data)
      space = Space.find_by(name: params[:room])
      space.messages.create!(sent_by: data['sent_by'], body: data['body'])

      ActionCable.server.broadcast("chat_#{params[:room]}", data)
    end
  end
end
