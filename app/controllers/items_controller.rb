class ItemsController < ApplicationController
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end

  def item_params
    params.require(:item).permit(:title, :content, :parent_id, :position)
  end
end
