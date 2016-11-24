module ApplicationHelper
  def bootstrap_alert_class(type)
    { "notice" => :success, "alert" => :danger }[type] ||= type.to_sym
  end
end
