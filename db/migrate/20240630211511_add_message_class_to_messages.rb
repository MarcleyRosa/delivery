class AddMessageClassToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :message_class, :string
  end
end
