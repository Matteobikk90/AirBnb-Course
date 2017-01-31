class BookingsController < ApplicationController
	before_action :authenticate_user!

	def create
		room = Room.find(params[:room_id])
		
		if  current_user == room.user
				redirect_to room, error: "You can't reserve your own room!"
		else
			@booking = current_user.bookings.create(booking_params)
				redirect_to @booking.room, notice: "Your booking has been created!"
		end
	end

	def preload
		room = Room.find(params[:room_id])
		today = Date.today
		bookings = room.bookings.where("start_date >= ? OR end_date >= ?", today, today)
	
		render json: bookings
	end

	def preview
		start_date = Date.parse(params[:start_date])
		end_date = Date.parse(params[:end_date])

		output = {
			conflict: is_conflict(start_date, end_date)
		}

		render json: output
	end

	def your_trips
		@trips = current_user.bookings
	end

	def your_bookings
		@rooms = current_user.rooms
	end

	private
		def booking_params
			params.require(:booking).permit(:start_date, :end_date, :price, :total, :room_id)
		end

		def is_conflict(start_date, end_date)
			room = Room.find(params[:room_id])

			check = room.bookings.where("? < start_date AND end_date < ?", start_date, end_date)
			check.size > 0? true : false
		end

end
