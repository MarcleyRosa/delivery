class MessagesController < ApplicationController
  def index
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]

    @messages = Message.where(sender_id: sender_id, receiver_id: receiver_id)
                       .or(Message.where(sender_id: receiver_id, receiver_id: sender_id))
                       .order(created_at: :asc)

    render json: @messages
  end

  def create
    message = Message.create!(message_params)
    ChatChannel.broadcast_to("chat_#{message.receiver_id}_#{message.sender_id}", message: render_message(message))
    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :content, :message_class)
  end

  def render_message(message)
    render(partial: 'messages/message', locals: { message: message })
  end
end
