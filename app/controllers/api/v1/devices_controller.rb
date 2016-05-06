class Api::V1::DevicesController < Api::V1::BaseController
  def create
    @device = Device.find_or_initialize_by(create_params.update(user: current_user))
    if @device.save
      head :ok
    else
      error!(:invalid_resource, @device.errors)
    end
  end

  def index
    expose Device.where(user: current_user)
  end

  def create_params
    params.require(:device).permit(:device_id, :device_platform)
  end
end
