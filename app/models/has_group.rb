class HasGroup < ApplicationRecord
  belongs_to :student
  belongs_to :group
  validate :student_unique_per_group

  private
  def student_unique_per_group
  	if self.class.exists?(:student_id => student_id, :group_id => group_id)
	  errors.add :student_id, 'Ya se encuentra en el grupo'
	end
  end
end
