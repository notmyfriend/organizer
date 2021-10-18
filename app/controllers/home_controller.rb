class HomeController < ApplicationController
  def index
    @query = params[:search_query]
    if @query
      begin
        organizations_by_name = Organization.search(
          @query,
          fields: ['name']
        ).map { |organization| organization }
        organizations_by_service = Service.search(
          @query,
          fields: [:name]
        # ).map { |service| [service, service.organizations] }
        ).map(&:organizations)
        organizations_by_service.flatten! unless organizations_by_service.empty?

        @organizations = organizations_by_name | organizations_by_service

      rescue
        organizations_by_name = Organization.find_by_sql(
          ['select * from organizations where name like ?', "%#{@query}%"]
        )
        organizations_by_service = Service.find_by_sql(
          ['select * from services where name like ?', "%#{@query}%"]
        # ).map { |service| [service, service.organizations] }
        ).map(&:organizations)
        organizations_by_service.flatten! unless organizations_by_service.empty?

        @organizations = organizations_by_name | organizations_by_service
      end
    # else
    #   @services = Service.all
    end
  end
end
