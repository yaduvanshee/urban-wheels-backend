class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :type
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.decimal :wallet_balance

      t.timestamps
    end
  end
end
