Deface::Override.new(:virtual_path  => "spree/shared/_head",
                     :insert_after => "code[erb-loud]:contains('javascript_include_tag')",
                     :name => "stripe_values",
                     :text => "<%= tag :meta, :name => 'stripe-key', :content => ENV['STRIPE_PUBLIC_KEY'] %>
                     <%= yield :dynamic_javascripts %>")
