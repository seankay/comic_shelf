module ApplicationHelper

  def days_remaining time
    pluralize((time - Time.now).to_i / 1.day, 'day')
  end

  def current_plan? plan
    current_store.subscription.plan.plan_identifier.eql?(plan)
  end
end
