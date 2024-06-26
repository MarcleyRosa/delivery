class MessagesController < ApplicationController
  def create
    message = Message.create!(message_params)
    ChatChannel.broadcast_to("chat_#{message.receiver_id}_#{message.sender_id}", message: render_message(message))
    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content)
  end

  def render_message(message)
    render(partial: 'messages/message', locals: { message: message })
  end
end
