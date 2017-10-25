class QueryEmpire
  class Engine < ::Rails::Engine
    isolate_namespace QueryEmpire

    ActiveSupport.on_load(:active_record) do
      require 'query_empire/active_record'
    end
  end
end
