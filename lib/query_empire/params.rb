class QueryEmpire::Params
  attr_accessor :table, :filters, :order_by, :order_direction,
    :columns, :headings, :limit, :page, :offset, :joins,
    :includes, :scopes

  def initialize(table:, includes: [], filters: [], joins: [], scopes: [],
    columns: [], order_by: nil, order_direction: nil, headings: false,
    limit: nil, page: nil, offset: nil)

    initialize_table(table)
    initialize_joins(joins)
    initialize_includes(includes)
    initialize_filters(filters)
    initialize_scopes(scopes)
    initialize_order(order_by, order_direction)
    initialize_columns(columns)
    initialize_limit(limit)
    initialize_headings(headings)
    initialize_page(page)
    initialize_offset(offset)
  end

  def to_json
    {
      table: table.to_s,
      filters: filters,
      order_by: order_by,
      order_direction: order_direction,
      columns: columns,
      headings: headings,
      limit: limit,
      page: page,
      offset: offset,
      joins: joins,
      includes: includes
    }.to_json
  end

  def order
    return nil if order_by.nil?
    "#{order_by} #{order_direction}"
  end

  private

  def initialize_filters(filters)
    @filters = []
    filters.each do |field, values|
      values.each do |operator, value|
        field_with_table_name = field.to_s
        @filters << QueryEmpire::Filter.new(field_with_table_name, operator.to_sym, value)
      end
    end
  end

  def initialize_table(table)
    @table = table
    @table = "::#{@table.camelize.singularize}".constantize if @table.is_a? String
  end

  def initialize_joins(joins)
    @joins = []
    joins = joins.split(',') if joins.is_a? String
    @joins = available_tables(joins)
  end

  def initialize_includes(includes)
    @includes = []
    includes = includes.split(',') if includes.is_a? String
    @includes = available_tables(includes)
  end

  def initialize_scopes(scopes)
    @scopes = []
    scopes.each do |*, scope|
      @scopes << QueryEmpire::Scope.new(
        name: scope['name'] || scope[:name],
        value: scope['value'] || scope[:value]
      )
    end
  end

  def initialize_offset(offset)
    return @offset = (page - 1) * limit if page && limit
    @offset = Integer(offset) if offset
  end

  def initialize_limit(limit)
    @limit = Integer(limit) if limit
  end

  def initialize_order(order_by, order_direction)
    @order_direction = order_direction&.upcase if order_direction
    @order_by = order_by if order_by
  end

  def initialize_columns(columns)
    @columns = begin
      columns.blank? ? table.columns.map(&:name) : columns
    rescue StandardError
      []
    end

    if (unknown_columns = (@columns - available_columns)).any?
      raise ArgumentError, "Wrong columns provided: #{unknown_columns.join(', ')}"
    end
  end

  def initialize_headings(headings)
    @headings = headings
  end

  def initialize_page(page)
    @page = Integer(page) if page
  end

  def available_columns
    column_map = []
    column_map << @columns
    return column_map.flatten if joins.blank? && includes.blank?
    @table.reflect_on_all_associations.each do |a|
      table_name = a.name.to_s
      if joins.include?(table_name.to_sym) || includes.include?(table_name.to_sym)
        class_to_create = a.options.dig(:class_name) || a.name
        table = class_to_create.to_s.singularize.classify.constantize
        column_map << table.columns.map { |a| "#{table_name}.#{a.name}" }
      end
    end
    column_map.flatten
  end

  def available_tables(joins_or_includes)
    return [] unless joins_or_includes

    filtered_tables = []
    model_belongs = @table.reflect_on_all_associations.collect(&:name)

    joins_or_includes.each do |r|
      rel = r.split(':')
      if rel.length == 1
        if model_belongs.include? rel.first.to_sym
          filtered_tables << rel.first.to_sym
        end
      else
        if model_belongs.include? rel.first.to_sym
          through_belongs = rel.first.camelize.constantize
            .reflect_on_all_associations.collect(&:name)
          if through_belongs.include? rel.second.to_sym
            filtered_tables << { rel.first.to_sym => rel.second.to_sym }
          end
        end
      end
    end
    filtered_tables
  end
end
