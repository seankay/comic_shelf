Deface::Override.new(:virtual_path => "spree/users/show",
                     :insert_after => "dl#user-info",
                     :name         => "plan_info",
                     :partial      => "plans/plan_info")

Deface::Override.new(:virtual_path => "spree/users/show",
                     :insert_after => "dl#plan",
                     :name         => "current_card",
                     :partial      => "subscriptions/credit_card_info")
