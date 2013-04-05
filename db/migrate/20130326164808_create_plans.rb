class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, :null            => false
      t.float :price, :null            => false
      t.integer :max_products, :null   => false
      t.string :plan_identifier, :null => false
      t.timestamps
    end
  end
end
