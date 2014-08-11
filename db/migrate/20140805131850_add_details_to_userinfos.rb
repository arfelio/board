class AddDetailsToUserinfos < ActiveRecord::Migration
  def change
    add_column :userinfos, :full_name, :string
    add_column :userinfos, :bday, :string
    add_column :userinfos, :zip, :string
  end
end
