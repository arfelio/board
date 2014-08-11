class AddLoginToUserinfos < ActiveRecord::Migration
  def change
    add_column :userinfos, :login, :string
  end
end
