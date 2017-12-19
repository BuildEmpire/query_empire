require 'query_empire/configuration'
require 'query_empire/engine'
require 'query_empire/filter'
require 'query_empire/params'
require 'query_empire/scope'

class QueryEmpire
  class << self
    attr_accessor :configuration

    def params(params, table: nil)
      params = format_params(params)
      params[:table] = table if table
      _params = {}
      [:filters, :order_by, :order_direction, :columns,
        :headings, :limit, :page, :offset, :joins,
        :includes, :scopes, :table].each do |key|
        _params[key] = params[key] if params[key]
      end

      Params.new(_params)
    rescue StandardError => e
      Rails.logger.error e
      nil
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    private
    def format_params(params)
      params = params.to_unsafe_h if params.respond_to? :to_unsafe_h
      params = params.with_indifferent_access
      namespace = self.configuration.parameters_namespace
      namespaced_params = params.extract!(namespace)
      params = params.merge namespaced_params[namespace]
      params
    end
  end
end
