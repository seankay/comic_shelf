module ApplicationHelper

  def trial_days_remaining
    pluralize((@subscription.trial_end_date - Time.now).to_i / 1.day, 'day')
  end

end
