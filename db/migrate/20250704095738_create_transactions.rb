class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :ride, null: false, foreign_key: true
      t.decimal :amount_paid
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
