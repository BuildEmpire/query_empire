require 'query_empire/engine'
require 'query_empire/filter'
require 'query_empire/params'
require 'query_empire/scope'

class QueryEmpire
  def self.params(params)
    params = params.with_indifferent_access
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
end
