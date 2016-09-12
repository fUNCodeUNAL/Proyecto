class GroupController < ApplicationController
	def new
		@group = Group.new
	end

	def create
		@group = Group.create(group_params)
		redirect_to teacher_groups_path(@group.teacher_id)
	end
	def destroy
		@group = Group.find(params[:id])
		@group.destroy
		redirect_to teacher_groups_path(@group.teacher_id)
	end

	private
	def group_params
		params.require(:group).permit(:name, :teacher_id)
	end
end
