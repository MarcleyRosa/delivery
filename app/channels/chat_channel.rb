class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:sender_id]}_#{params[:receiver_id]}"
    stream_from "chat_#{params[:receiver_id]}_#{params[:sender_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    message_class = params[:message_class]
    Message.create!(sender_id: sender_id, receiver_id: receiver_id, content: data['message'], message_class: message_class )
    message = data['message']
    
    ActionCable.server.broadcast("chat_#{params[:sender_id]}_#{params[:receiver_id]}", { message: message, sender_id: params[:sender_id] })
    ActionCable.server.broadcast("chat_#{params[:receiver_id]}_#{params[:sender_id]}", { message: message, sender_id: params[:sender_id] })
  end
end
