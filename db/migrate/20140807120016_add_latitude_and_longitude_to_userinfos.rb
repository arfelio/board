class AddLatitudeAndLongitudeToUserinfos < ActiveRecord::Migration
  def change
    add_column :userinfos, :latitude, :float
    add_column :userinfos, :longitude, :float
  end
end
