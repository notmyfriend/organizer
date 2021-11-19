class WorkersController < ApplicationController
  before_action :find_organization_service

  def new
    @worker = @organization_service.workers.new
  end

  def create
    @worker = @organization_service.workers.new(worker_params)

    if @worker.save
      redirect_to organization_path(@organization_service.organization_id)
    else
      render :new
    end
  end

  def edit
    @worker = @organization_service.workers.find(params[:id])
  end

  def update
    @worker = @organization_service.workers.find(params[:id])

    if @worker.update(worker_params)
      redirect_to organization_path(@organization_service.organization_id)
    else
      render :edit
    end
  end

  def destroy
    @worker = Worker.find(params[:id])
    @worker.destroy
  end

  private

  def worker_params
    params.require(:worker).permit(:first_name, :last_name, :qualification)
  end

  def find_organization_service
    @organization_service = OrganizationService.find(params[:organization_service_id])
  end
end
