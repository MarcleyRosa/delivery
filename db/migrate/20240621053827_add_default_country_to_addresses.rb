class AddDefaultCountryToAddresses < ActiveRecord::Migration[7.1]
  def change
    change_column_default :addresses, :country, 'Brasil'
  end
end
