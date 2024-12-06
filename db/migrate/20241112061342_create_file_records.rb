class CreateFileRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :file_records do |t|
      t.string :name
      t.string :type
      t.string :uid

      t.timestamps
    end
  end
end
