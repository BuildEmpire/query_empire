class QueryEmpire::Filter
  attr_accessor :field, :operator, :value

  def initialize(field, operator, value)
    @field = field
    @operator = operator
    @value = value
  end

  def query
    field = field_reference
    case operator
      when :lt
        return "#{field} < ?", value
      when :lte
        return "#{field} <= ?", value
      when :gt
        return "#{field} > ?", value
      when :gte
        return "#{field} >= ?", value
      when :eq
        return "#{field} = ?", value
      when :neq
        return "#{field} != ?", value
      when :is
        return "#{field} IS #{value}"
      when :is_not
        return "#{field} IS NOT #{value}"
      when :like
        return "lower(#{field}) LIKE lower(?)", value
      when :in
        return "#{field} in (?)", value
      when :not_in
        return "#{field} not in (?)", value
    end
  end

  private

  def field_reference
    field.split('.').map { |reference_part| "\"#{reference_part}\"" }.join '.'
  end
end
