class Room < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_many :bookings

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accomodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
  validates :price, presence: true
  validates :listing_name, presence: true, length: {maximum: 50}
  validates :summary, presence: true, length: {maximum: 500}
  validates :address, presence: true
  
  # def show_first_photo(size)
  #   if self.photos.length == 0
  #     'http://img.astaingriglia.com/all/no_image.jpg'
  #   else
  #     self.photos[0].image.url(size)
  #   end
  # end

end
