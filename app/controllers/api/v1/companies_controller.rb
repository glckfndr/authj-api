class Api::V1::CompaniesController < ApiController
  before_action :set_company, only: %i[show update destroy]

  def index
    @companies = current_user.companies
    render json: @companies, status: :ok
  end

  def show
    render json: @company, status: :ok
  end

  def create
    @company = current_user.companies.build(company_params)
    if @company.save
      render json: @company, status: :created
    else
      render json: { errors: @company.errors.full_messages, status: 'can not create' },
             status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      render json: @company, status: :ok
    else
      render json: { errors: @company.errors.full_messages, status: 'can not update' },
             status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    render json: { status: 'Company deleted successfully' }, status: :ok
  end

  private

  def set_company
    # @company = Company.find(params[:id])
    @company = current_user.companies.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :unauthorized
  end

  def company_params
    params.require(:company).permit(:name, :address, :established_year, :user_id)
  end
end
