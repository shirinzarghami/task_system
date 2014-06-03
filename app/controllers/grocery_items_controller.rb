class GroceryItemsController < ApplicationController

  before_filter :find_community

  def index
    @grocery_items = @community.grocery_items
  end

  def create
    @community.grocery_items.create 
  end
end