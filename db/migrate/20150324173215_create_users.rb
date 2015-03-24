class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :referral_code
      t.references :referrer, index: true

      t.timestamps null: false
    end
    add_foreign_key :users, :referrers
  end
end
