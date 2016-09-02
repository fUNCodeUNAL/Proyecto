class UserController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.create(params)
		if @user.save
			redirect_to root
		else
			render :new
		end

	end



end
