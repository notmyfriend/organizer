class SearchController < ApplicationController
  def index
    @query = params[:search_query]
    redirect_to root_path if @query.nil? || @query.empty?

    @organizations_by_name,
    @organizations_by_services_hash = elasticsearch_available? ? search_elasticsearch(@query) : search_db(@query)

    return unless elasticsearch_available? && @organizations_by_name.empty? && @organizations_by_services_hash.empty?

    @organizations_by_name, @organizations_by_services_hash = search_db(@query)
  end

  def autocomplete
    @autocomplete_results = Organization.search(
      params[:query],
      fields: ['name'],
      match: :word_start,
      limit: 10,
      load: false,
      misspellings: { below: 5 }
    ).map(&:name) | Service.search(
      params[:query],
      fields: ['name'],
      match: :word_start,
      limit: 10,
      load: false,
      misspellings: { below: 5 }
    ).map(&:name)

    render json: @autocomplete_results
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
    organizations_by_name = Organization.where('name like ?', "#{query}%").to_a
    services = Service.where('name like ?', "#{query}%").to_a

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
