class AddColumnsToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :image, :string
    add_column :merchants, :enabled, :boolean, default: true 
  end
end
