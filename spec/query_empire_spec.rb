require 'spec_helper'

RSpec.describe QueryEmpire do

  let(:params_hash) {
    {
      table: 'people',
      filters: { id: { gt: 1, lt: 4 } },
      headings: true
    }
  }

  context '#params' do
    it 'returns initialized params' do
      res = QueryEmpire.params(params_hash)
      expect(res).to be_a QueryEmpire::Params
    end
  end
end
