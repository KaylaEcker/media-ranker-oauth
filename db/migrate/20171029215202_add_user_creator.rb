class AddUserCreator < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :user_creator, :integer
  end
end
