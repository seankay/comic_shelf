module ApplicationHelper

  def days_remaining time
    pluralize((time - Time.now).to_i / 1.day, 'day')
  end
end
