require 'rails_helper'

describe QueryEmpire::Params do

  let(:params_hash) {
    {
      user_id: 1,
      filters: { id: { gt: 1, lt: 4 }, warehouse_id: { eq: 1 } },
      sort_by: :column,
      order_by: '',
      columns: '',
      headings: true
    }
  }

  it 'initializes object with params hash with table name as a singular string' do
    params = QueryEmpire::Params.new(params_hash.merge(table: 'unpack_item'))
    expect(params.table).to eq UnpackItem
    expect(params.order_by).to eq nil
    expect(params.headings).to eq params_hash[:headings]
    expect(params.filters.size).to eq 3
    expect(params.filters.first).to be_a QueryEmpire::Filter
  end

  it 'initializes object with params hash with table name as a plural string' do
    params = QueryEmpire::Params.new(params_hash.merge(table: 'unpack_items'))
    expect(params.table).to eq UnpackItem
    expect(params.order_by).to eq nil
    expect(params.headings).to eq params_hash[:headings]
    expect(params.filters.size).to eq 3
    expect(params.filters.first).to be_a QueryEmpire::Filter
  end

  it 'initializes object with params hash with table name as a class' do
    params = QueryEmpire::Params.new(params_hash.merge(table: UnpackItem))
    expect(params.table).to eq UnpackItem
    expect(params.order_by).to eq nil
    expect(params.headings).to eq params_hash[:headings]
    expect(params.filters.size).to eq 3
    expect(params.filters.first).to be_a QueryEmpire::Filter
  end

  it 'fails to initialize with invalid table name' do
    params = QueryEmpire::Params.new(params_hash.merge(table: 'some_name'))
    expect(params.errors).not_to be_empty
  end

  it 'fails to initialize with no table name' do
    params = QueryEmpire::Params.new(params_hash)
    expect(params.errors).not_to be_empty
  end

  it 'initializes object with limit and offset convertable to number' do
    params = QueryEmpire::Params.new(
      params_hash.merge(table: UnpackItem, offset: '2', limit: '5')
    )
    expect(params.errors).to be_empty
  end

  it 'fails to initialize object with limit and offset not convertable to number' do
    params = QueryEmpire::Params.new(
      params_hash.merge(table: UnpackItem, offset: 'dsfsf', limit: 'dsf')
    )
    expect(params.errors).not_to be_empty
  end
end
