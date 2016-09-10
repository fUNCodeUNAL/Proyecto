class CreateHasGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :has_groups do |t|
      t.references :student, foreign_key: true, type: :string
      t.references :group, foreign_key: true
    end
  end
end
