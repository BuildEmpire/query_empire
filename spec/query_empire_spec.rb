require 'spec_helper'

RSpec.describe QueryEmpire do

  let(:params_hash) {
    {
      table: 'people',
      filters: { id: { gt: 1, lt: 4 } },
      headings: true
    }
  }

  describe '#params' do
    it 'returns initialized params' do
      res = QueryEmpire.params(params_hash)
      expect(res).to be_a QueryEmpire::Params
    end
  end

  describe '#configure' do
    let(:namespace) { :query_params }

    before do
      QueryEmpire.configure do |config|
        config.parameters_namespace = namespace
      end
    end

    it 'saves configuration' do
      expect(QueryEmpire.configuration.parameters_namespace).to eq namespace
    end

    context 'parameters_namespace=query_params' do
      it 'allows to parse namespaced params' do
        res = QueryEmpire.params(query_params: params_hash)
        expect(res.table).to eq Person
      end

      it 'allows to parse top-level params if no namespaced provided' do
        res = QueryEmpire.params(params_hash)
        expect(res.table).to eq Person
      end
    end
  end
end
