class Merchants::ItemsController < Merchants::BaseController
  def index
    @merchant = User.find(current_user.id)
  end

  def new
    @item = Item.new(params[:merchant_id])
  end
end
