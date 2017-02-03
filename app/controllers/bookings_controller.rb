class BookingsController < ApplicationController
	before_action :authenticate_user!, except: [:notify]

	def create
		@booking = current_user.bookings.create(booking_params)

		if @booking
			# send resquest to paypal
			values = {
				business: 'matteo.soresini90-facilitator@gmail.com',
				cmd: '_xclick',
				upload: 1,
				notify_url: 'http://01877ba1.ngrok.io/notify',
				amount:@booking.total,
				item_name: @booking.room.listing_name,
				item_number: @booking.id,
				quantity: '1',
				return: 'http://01877ba1.ngrok.io/your_trips'
			}
			redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
		else
			redirect_to @booking.room, alert: "Ops, something went wrong..."
		end
		
		# if  current_user == room.user
		# 		redirect_to room, error: "You can't reserve your own room!"
		# else
		# 	@booking = current_user.bookings.create(booking_params)
		# 		redirect_to @booking.room, notice: "Your booking has been created!"
		# end
	end

	protect_from_forgery except: [:notify]
	def notify
		params.permit!
		status = params[:payment_status]

		booking = Booking.find(params[:item_number])

		if status = "Completed"
			booking.update_attributes status: true
		else
			booking.destroy
		end

		render nothing: true
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

	protect_from_forgery except: [:your_trips]
	def your_trips
		@trips = current_user.bookings.where("status = ?", true)
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
