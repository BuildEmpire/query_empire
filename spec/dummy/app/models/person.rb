class Person < ActiveRecord::Base
  scope :named, ->(name) { where('name = ?', name) }
end
