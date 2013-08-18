module MailerHelper
  def default_from
    CONFIG[:email_settings].try(:symbolize_keys).try(:[], :user_name) || "tasksystem@example.com"
  end
end
