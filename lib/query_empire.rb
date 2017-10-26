require 'query_empire/configuration'
require 'query_empire/engine'
require 'query_empire/filter'
require 'query_empire/params'
require 'query_empire/scope'

class QueryEmpire
  class << self
    attr_accessor :configuration

    def params(params)
      params = params.to_h.with_indifferent_access
      namespace = self.configuration.parameters_namespace
      params = params[namespace] if params[namespace]
      _params = {}
      [:filters, :order_by, :order_direction,
        :columns, :headings, :limit, :page, :offset, :joins,
        :includes, :scopes, :table].each do |key|
        _params[key] = params[key] if params[key]
      end
      Params.new(_params)
    rescue StandardError
      nil
    end


    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
