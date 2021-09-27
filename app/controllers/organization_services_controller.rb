class OrganizationServicesController < ApplicationController
  def new
    @organization_service = OrganizationService.new
  end

  def create
    @organization_service = OrganizationService.new(organization_service_params)

    if @organization_service.save
      redirect_to edit_organization_path(organization_service_params[:organization_id])
    else
      render :new
    end
  end

  def destroy
    @organization_service = OrganizationService.find(params[:id])
    organization = @organization_service.organization_id

    @organization_service.destroy

    redirect_to edit_organization_path(organization)
  end

  private

  def organization_service_params
    params.require(:organization_service).permit(:organization_id, :service_id)
  end
end
