class Admin::ItemsController < Admin::BaseController
  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all_active
      @top_items = Item.popular_items(5, 'DESC')
      @bottom_items = Item.popular_items(5, 'ASC')
    end
  end
end
