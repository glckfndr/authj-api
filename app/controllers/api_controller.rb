class ApiController < ApplicationController
  before_action :authenticate_user!
end
# Compare this snippet from app/controllers/api/v1/companies_controller.rb: 
