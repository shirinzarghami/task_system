module InvitationsHelper

  def invitation_status invitation
    element_class = case invitation.status 
      when 'denied' then 'error-text'
      when 'accepted' then 'valid-text'
      else ''
    end

    content_tag(:td, class: element_class) {t("activerecord.values.#{invitation.status}")}
  end
end
