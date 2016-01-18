# == Schema Information
#
# Table name: parks
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :string
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Park < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode
end
