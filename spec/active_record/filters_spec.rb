require 'spec_helper'

RSpec.describe 'ActiveRecord' do

  let(:people) { create_list :person, 10 }

  context 'filters provided' do
    it 'finds records' do
      included = Person.create! name: 'Marcin'
      Person.create! name: 'Fred'
      params = {
        filters: {
          name: { eq: 'Marcin' }
        }
      }
      expect(Person.filter(params)).to eq [included]
    end

    it 'finds records' do
      Person.create! [
        { name: 'Marcin' },
        { name: 'Fred' },
        { name: 'Arnis' },
        { name: 'Justas' }
      ]
      params = {
        filters: {
          id: { gt: 1, lte: 3 }
        }
      }
      expect(Person.filter(params).pluck(:id)).to eq [2,3]
    end
  end
end
