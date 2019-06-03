class Trip < ActiveRecord::Base
	has_many :bookings
	has_many :stops, :through => :bookings
	belongs_to :user
end