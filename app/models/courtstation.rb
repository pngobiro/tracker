class Courtstation < ActiveRecord::Base
  has_many :batches
  has_many :fileactions
  has_many :casefiles
  has_many :movements, through: :casefiles
  attr_accessible :name, :typeofcourt

def self.option_for_courtstations
self.pluck(:name)
end
end
