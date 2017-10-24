class QueryEmpire::Params
  attr_accessor :table, :filters, :order_by, :order_direction,
    :columns, :headings, :limit, :page, :offset, :joins,
    :includes, :scopes, :errors

  def initialize(table:, includes: [], filters: [], joins: [], scopes: [],
    columns: [], order_by: nil, order_direction: nil, headings: false,
    limit: nil, page: nil, offset: nil)

    @errors = []
    @includes = []
    @filters = []
    @scopes = []
    @joins = []

    @table = table
    @table = @table.constantize if @table.is_a? String

    @joins = find_joins(joins)
    @includes = find_includes(includes)

    filters.each do |field, values|
      values.each do |operator, value|
        field_with_table_name = field.to_s
        @filters << QueryEmpire::Filter.new(field_with_table_name, operator.to_sym, value)
      end
    end

    scopes.each do |*, scope|
      @scopes << QueryEmpire::Scope.new(
        name: scope['name'],
        value: scope['value']
      )
    end

    @order_by = order_by unless order_by.blank?
    @order_direction = order_direction.upcase unless order_direction.blank?

    find_columns(columns)

    if (unknown_columns = (@columns - available_columns)).any?
      raise ArgumentError, "Wrong columns provided: #{unknown_columns.join(', ')}"
    end

    find_limit(limit)
    find_offset(offset)

    @headings = headings
    @page = Integer(page) if page
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

  def offset_f
    return (page - 1) * limit unless page.blank? or limit.blank?
    offset unless offset.blank? or !page.blank?
    nil
  end

  private

  def find_joins(joins)
    joins = joins.split(',') if joins.is_a? String
    available_tables(joins)
  end

  def find_includes(includes)
    includes = includes.split(',') if includes.is_a? String
    available_tables(includes)
  end

  def find_offset(offset)
    @offset = Integer(offset) if offset
  rescue StandardError
    nil
  end

  def find_limit(limit)
    @limit = Integer(limit) if limit
  rescue StandardError
    nil
  end

  def find_columns(columns)
    @columns = columns.blank? ? table.columns.map(&:name) : columns
  rescue StandardError
    []
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
