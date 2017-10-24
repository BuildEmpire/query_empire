require 'rails_helper'

describe QueryEmpire::Filter do
  it 'assigns field and operator on initialize' do
    filter = QueryEmpire::Filter.new('abc', :like, 'sdfe')
    expect(filter.field).to eq 'abc'
    expect(filter.operator).to eq :like
    expect(filter.value).to eq 'sdfe'
  end
end
