require 'spec_helper'

RSpec.describe QueryEmpire::Params do

  let(:params_hash) {
    {
      table: 'people',
      filters: { id: { gt: 1, lt: 4 }, warehouse_id: { eq: 1 } },
      headings: true
    }
  }

  context '#new' do
    context 'valid params' do
      it 'initializes object' do
        params = QueryEmpire::Params.new(params_hash)
        expect(params.table).to eq Person
        expect(params.order_by).to eq nil
        expect(params.headings).to eq params_hash[:headings]
        expect(params.filters.size).to eq 3
        expect(params.filters.first).to be_a QueryEmpire::Filter
      end
    end

    context 'model name as table provided' do
      it 'initializes object' do
        params = QueryEmpire::Params.new(params_hash.merge(table: Person))
        expect(params.table).to eq Person
      end
    end

    context 'invalid table name provided' do
      it 'raises error' do
        expect {
          QueryEmpire::Params.new(params_hash.merge(table: 'some_name'))
        }.to raise_error NameError
      end
    end

    context 'no table name provided' do
      it 'raises error' do
        expect {
          QueryEmpire::Params.new(params_hash.merge(table: nil))
        }.to raise_error NameError
      end
    end

    context 'limit and offset not convertible to a number' do
      it 'initializes object with converted limit and offset' do
        params = QueryEmpire::Params.new(
          params_hash.merge(table: Person, offset: '2', limit: '5')
        )
        expect(params.offset).to eq 2
        expect(params.limit).to eq 5
      end
    end

    context 'limit and offset not convertible to a number' do
      it 'initializes object with nil as limit and offset' do
        expect {
          QueryEmpire::Params.new(
            params_hash.merge(table: Person, offset: 'dsfsf', limit: 'dsf')
          )
        }.to raise_error ArgumentError
      end
    end
  end
end
