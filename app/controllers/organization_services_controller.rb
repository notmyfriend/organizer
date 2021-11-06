class OrganizationServicesController < ApplicationController
  before_action :find_organization

  def new
    @organization_service = @organization.organization_services.new
  end

  def create
    @organization_service = @organization.organization_services.new(organization_service_params)

    if @organization_service.save
      redirect_to edit_organization_path(@organization)
    else
      render :new
    end
  end

  def destroy
    @organization_service = OrganizationService.find(params[:id])
    @organization_service.destroy

    redirect_to edit_organization_path(@organization)
  end

  private

  def organization_service_params
    params.require(:organization_service).permit(:service_id)
  end

  def find_organization
    @organization = Organization.find(params[:organization_id])
  end
end
