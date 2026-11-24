class AddColumnToAdvertisements < ActiveRecord::Migration[4.2]
  def change
    add_column :advertisements, :category_id, :integer
  end
end
