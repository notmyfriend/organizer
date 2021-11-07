class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    begin
      if @organization.save
        redirect_to @organization
      else
        render :new
      end
    rescue ActiveRecord::RecordNotUnique
      render :new
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])

    begin
      if @organization.update(organization_params)
        redirect_to @organization
      else
        render :edit
      end
    rescue ActiveRecord::RecordNotUnique
      render :edit
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    redirect_to organizations_path
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :description, :user_id)
  end
end
