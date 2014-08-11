class AddUserIdToUserinfos < ActiveRecord::Migration
  def change
    add_column :userinfos, :user_id, :integer
  end
end
