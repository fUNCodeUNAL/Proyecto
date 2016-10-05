class GroupController < ApplicationController
  before_action :authenticate_user!
  def create
    @group = Group.create(group_params)
    redirect_to teacher_groups_show_path
  end
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to teacher_groups_show_path
  end
  def edit
    @group = Group.find(params[:id_group])
  end
  def delete_student
    @record = HasGroup.find_by( group_id: params[:id_group], student_id: params[:id_student] )
    @record.destroy
    redirect_to teacher_groups_edit_path(params[:id_group])
  end
  def add_student
    user = User.find_by(email: has_group_params[:student_email])
    if user == nil
      redirect_to pages_wrong_path
    else
      HasGroup.create(group_id: has_group_params[:id_group], student_id: user.id)
      redirect_to teacher_groups_edit_path(has_group_params[:id_group])
    end
    
  end

  private
  def group_params
    params.require(:group).permit(:name, :teacher_id)
  end
  def has_group_params
    params.require(:info_student).permit(:student_email, :id_group)
  end
end
