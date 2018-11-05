class AddVipToChapters < ActiveRecord::Migration[5.2]
  def change
    add_column :chapters, :vip, :boolean
  end
end
