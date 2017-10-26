class Person < ActiveRecord::Base
  belongs_to :company
  scope :named, ->(name) { where('name = ?', name) }
end
