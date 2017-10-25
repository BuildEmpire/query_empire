module QueryEmpire
  module ActiveRecord
    extend ActiveSupport::Concern

    class_methods do
      def filter(raw_params = {})
        params = prepare_params(raw_params)

        results = all
        params.joins.each { |join| results = results.joins join }
        params.includes.each { |include| results = results.includes include }
        params.filters.each { |filter| results = results.where filter.query }
        params.scopes.each do |_scope|
          results = results.send(_scope.name, _scope.value)
        end
        results = results.order params.order if params.order
        results = results.limit params.limit if params.limit
        results = results.offset(params.offset_f) if params.offset_f
        results
      end

      private

      def prepare_params(raw_params)
        params = { table: self }
        [:filters, :order_by, :order_direction,
          :columns, :headings, :limit, :page, :offset, :joins,
          :includes, :scopes].each do |key|
          params[key] = raw_params[key] if raw_params[key]
        end

        QueryEmpire::Params.new(params)
      end
    end
  end
end

ActiveRecord::Base.send(:include, QueryEmpire::ActiveRecord)
