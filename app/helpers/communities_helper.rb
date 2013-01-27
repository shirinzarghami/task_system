module CommunitiesHelper

  def first_members community, number=5
    community.members.first(number).map(&:name).join(', ') 
  end

  def role_name role
    role == 'admin' ? t('activerecord.values.admin') : t('activerecord.values.normal')
  end
end
