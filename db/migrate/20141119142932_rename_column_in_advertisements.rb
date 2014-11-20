class RenameColumnInAdvertisements < ActiveRecord::Migration
  def change
  	change_table :advertisements do |t|
      t.rename :author, :title
    end
  end
end
