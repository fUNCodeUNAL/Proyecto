class CreateGroupAndContests < ActiveRecord::Migration[5.0]
  def change
    create_table :group_and_contests do |t|
      t.integer :group_id
      t.integer :contest_id

      t.timestamps
    end
  end
end
