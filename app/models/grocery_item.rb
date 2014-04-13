class GroceryItem < ActiveRecord::Base
  attr_accessible :brand, :community_id, :deadline, :name, :number, :user_id

  belongs_to :community
  belongs_to :user

end
