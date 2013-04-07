class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :email, :null             => false
      t.boolean :card_provided, :default => false
      t.references :plan, :null          => false
      t.references :store, :null         => false
      t.datetime :canceled_at
      t.datetime :cancelation_date
      t.datetime :trial_end_date
      t.string :stripe_customer_token
      t.timestamps
    end
  end
end
