module MailerHelper
  def default_from
    CONFIG[:email_settings].try(:symbolize_keys).try(:[], :default_from) || "tasksystem@example.com"
  end
end
