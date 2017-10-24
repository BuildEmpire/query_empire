class QueryEmpire::Scope
  attr_accessor :name, :value

  def initialize(name:, value: nil)
    @name = name
    @value = value
  end
end
