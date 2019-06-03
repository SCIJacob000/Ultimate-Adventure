class Stop < ActiveRecord::Base
	has_many :bookings
	has_many :trips, :through => :bookings
end