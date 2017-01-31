class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]

  def index
    @rooms = current_user.rooms
  end

  def show
    @photos = @room.photos
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save

      if params[:images] 
        params[:images].each do |image|
          @room.photos.create(image: image)
        end
      end

      @photos = @room.photos
      redirect_to edit_room_path(@room), notice: "Saved..."
    else
      flash[:alert] = "Please provide all information for this room, included a photo."
      render :new
    end
  end

  def edit
    if current_user.id == @room.user.id
      @photos = @room.photos
    else
      redirect_to root_path, notice: "You don't have permission."
    end
  end

  def update
    if @room.update(room_params)

      if params[:images] 
        params[:images].each do |image|
          @room.photos.create(image: image)
        end
      end

      redirect_to edit_room_path(@room), notice: "Updated..."
    else
      flash[:alert] = "Please provide all information for this room, included a photo."
      render :edit
    end
  end

  # def show_first_photo(size)
  #     if self.photos.length == 0
  #       'http://kermisland.be/wp-content/uploads/2015/11/no-image.png'
  #     else
  #       self.photos[0].image.url(size)
  #     end
  # end

  private
    def set_room
      @room = Room.find(params[:id]) 
    end

    def room_params
      params.require(:room).permit(:home_type, :room_type, :accomodate, :bed_room, :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_air, :is_heating, :is_internet, :price, :active)
    end
end
