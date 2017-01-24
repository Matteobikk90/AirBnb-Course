class BookingsController < ApplicationController
	before_action :authenticate_user!

	def create
		@booking = current_user.bookings.create(booking_params)

		redirect_to @booking.room, notice: "Your booking has been created!"
	end

	private
		def booking_params
			params.require(:booking).permit(:start_date, :end_date, :price, :total, :room_id)
		end

end
