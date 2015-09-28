class AddKlasToUser < ActiveRecord::Migration
  def change
    add_column :users, :klas, :integer
  end
end
