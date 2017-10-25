require 'spec_helper'

RSpec.describe 'ActiveRecord' do

  context 'limit provided' do

    it 'returns good amount of records' do
      Person.create! [
        { name: 'Alberto' },
        { name: 'Fred' },
        { name: 'Tim' },
        { name: 'Justas' }
      ]

      params = {
        limit: 1
      }

      expect(Person.filter(params).size).to eq 1
    end
  end
end
