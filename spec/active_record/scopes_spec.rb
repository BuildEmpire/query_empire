require 'spec_helper'

RSpec.describe 'ActiveRecord' do

  context 'scope provided' do

    it 'finds records' do
      people = Person.create! [
        { name: 'Marcin' },
        { name: 'Fred' },
        { name: 'Arnis' },
        { name: 'Justas' }
      ]

      params = {
        scopes: [
          name: 'named',
          value: 'Marcin'
        ]
      }

      expect(Person.filter(params)).to eq [people.first]
    end
  end
end
