class ChatChannel < ApplicationCable::Channel
  def subscribed
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]

    # Stream for both directions
    stream_from "chat_channel_#{sender_id}_#{receiver_id}"
    stream_from "chat_channel_#{receiver_id}_#{sender_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    message = Message.create!(sender_id: sender_id, receiver_id: receiver_id, content: data['message'])

    # Broadcast to both sender and receiver streams
    ActionCable.server.broadcast("chat_channel_#{sender_id}_#{receiver_id}", { message: render_message(message) })
    ActionCable.server.broadcast("chat_channel_#{receiver_id}_#{sender_id}", { message: render_message(message) })
  end

  private

  def render_message(message)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message }
    )
  end
end
