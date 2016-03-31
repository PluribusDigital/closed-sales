class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.string :sale_id
      t.string :site_name
      t.date :date_sold
      t.string :loan_type
      t.string :quality
      t.integer :number_of_loans
      t.integer :book_value
      t.integer :sales_price
      t.string :winning_bidder
      t.string :address

      t.timestamps null: false
    end
  end
end
