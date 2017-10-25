class QueryEmpire
  module ActiveRecord
    extend ActiveSupport::Concern

    class_methods do
      def filter(raw_params = {})
        params = QueryEmpire.params(raw_params.merge(table: self))

        results = all
        params.joins.each { |join| results = results.joins join }
        params.includes.each { |include| results = results.includes include }
        params.filters.each { |filter| results = results.where filter.query }
        params.scopes.each do |_scope|
          results = results.send(_scope.name, _scope.value)
        end
        results = results.order params.order if params.order
        results = results.limit params.limit if params.limit
        results = results.offset params.offset if params.offset
        results
      end
    end
  end
end

ActiveRecord::Base.send(:include, QueryEmpire::ActiveRecord)
