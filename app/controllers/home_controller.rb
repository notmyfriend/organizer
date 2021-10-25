class HomeController < ApplicationController
  def index
    @query = params[:search_query]
    return unless @query

    @organizations_by_name,
    @organizations_by_services_hash = elasticsearch_available? ? search_elasticsearch(@query) : search_db(@query)
  end

  private

  def elasticsearch_available?
    response = Faraday.get 'http://localhost:9200'
    response.status == 200
  rescue Faraday::ConnectionFailed
    false
  end

  def search_elasticsearch(query)
    organizations_by_name = Organization.search(
      query,
      fields: ['name']
    ).to_a
    services = Service.search(
      query,
      fields: [:name]
    ).to_a

    process_search_results(organizations_by_name, services)
  end

  def search_db(query)
    organizations_by_name = Organization.where('name like ?', "%#{query}%").to_a
    services = Service.where('name like ?', "%#{query}%").to_a

    process_search_results(organizations_by_name, services)
  end

  def process_search_results(organizations_by_name, services)
    services.delete_if { |service| service.organizations.empty? }

    organizations_by_services = services.map(&:organizations).flatten.uniq
    organizations_by_name -= organizations_by_name & organizations_by_services

    organizations_by_services_hash = {}
    organizations_by_services.each do |organization|
      organizations_by_services_hash[organization] = []
      services.each do |service|
        organization.services.include?(service) && organizations_by_services_hash[organization] << service
      end
    end

    [organizations_by_name, organizations_by_services_hash]
  end
end
