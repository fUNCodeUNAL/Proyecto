class GroupController < ApplicationController
	def new
		@group = Group.new
		@group.teacher_id = params[:teacher_id]
	end
	def create
		@group = Group.new(group_params)
		path_home = '/teacher/'+@group.teacher_id
		if @group.save
			redirect_to path_home
		else
			render :new
		end
	end
	def destroy
		@group = Group.find(params[:id])
		path_home = '/teacher/'+@group.teacher_id

		@group.destroy
		redirect_to path_home
	end

	private
	def group_params
		params.require(:group).permit(:name, :teacher_id)
	end
end
