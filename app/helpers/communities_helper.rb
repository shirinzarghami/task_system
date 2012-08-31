module CommunitiesHelper

  def first_members community, number=5
    community.members.first(number).map(&:name).join(', ') 
  end
end
