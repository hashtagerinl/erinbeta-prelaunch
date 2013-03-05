class RegistrationsController < ApplicationController
	protected

	def after_inactive_sign_up_path_for(resource)
		'/thankyou.html'
	end

	def after_sign_up_path_for(resource)
		redirect_to root_path
	end
