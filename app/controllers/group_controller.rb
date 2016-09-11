class GroupController < ApplicationController
	def new
		@group = Group.new
		@group.teacher_id = params[:teacher_id]
	end
	def create
		@group = Group.new(group_params)
		if @group.save
			redirect_to '/teacher/'+@group.teacher_id
		else
			render :new
		end
	end

	private
	def group_params
		params.require(:group).permit(:name, :teacher_id)
	end
end
