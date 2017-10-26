require 'spec_helper'

RSpec.describe 'ActiveRecord' do

  context 'joins provided' do
    it 'filters by joined model column' do
      companies = Company.create! [{ name: 'comp1' }, { name: 'comp1' }]

      Person.create! [
        { name: 'Arnis', company: companies.first },
        { name: 'Fred', company: companies.first },
        { name: 'Marcin', company: companies.last },
        { name: 'Justas', company: companies.last },
        { name: 'Lapsa', company: companies.first },
      ]

      params = {
        joins: 'company',
        table: 'person',
        filters: { 'companies.id' => { gt: 1, lte: 2  } },
      }

      expect(Person.filter(params).pluck(:id)).to eq [3, 4]
    end
  end
end
