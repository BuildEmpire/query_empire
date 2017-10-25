require 'spec_helper'
require 'pry'

RSpec.describe QueryEmpire::Filter do

  data_sets = [
    { operator: :lt, value: 2, result: ["\"field\" < ?", 2] },
    { operator: :lte, value: 2, result: ["\"field\" <= ?", 2] },
    { operator: :gt, value: 2, result: ["\"field\" > ?", 2] },
    { operator: :gte, value: 2, result: ["\"field\" >= ?", 2] },
    { operator: :eq, value: 2, result: ["\"field\" = ?", 2] },
    { operator: :neq, value: 2, result: ["\"field\" != ?", 2] },
    { operator: :is, value: 2, result: ["\"field\" IS ?", 2] },
    { operator: :is_not, value: 2, result: ["\"field\" IS NOT ?", 2] },
    { operator: :like, value: 'Asd', result: ["\"field\" LIKE ?", 'Asd'] },
    { operator: :case_insensitive_like, value: 'Asd', result: ["lower(\"field\") LIKE lower(?)", "asd"] },
    { operator: :in, value: [2, 3, 4], result: ["\"field\" IN (?)", [2,3,4]] },
  ]

  data_sets.each do |set|
    it "returns valid #{set[:operator]} query" do
      expect(
        described_class.new('field', set[:operator], set[:value]).query
      ).to eq(set[:result])
    end
  end
end
