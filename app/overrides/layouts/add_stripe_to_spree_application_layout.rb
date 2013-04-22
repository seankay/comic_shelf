Deface::Override.new(:virtual_path  => "spree/shared/_head",
                     :insert_after => "code[erb-loud]:contains('javascript_include_tag')",
                     :name => "stripe_values",
                     :text => "<%= tag :meta, :name => 'stripe-key', :content => ENV['STRIPE_PUBLIC_KEY'] %>
                     <%= yield :dynamic_javascripts %>")

Deface::Override.new(:virtual_path  => "spree/admin/shared/_head",
                     :insert_after => "code[erb-loud]:contains('javascript_include_tag')",
                     :name => "stripe_values",
                     :text => "<%= tag :meta, :name => 'stripe-key', :content => ENV['STRIPE_PUBLIC_KEY'] %>
                     <%= yield :dynamic_javascripts %>",
                    :original => '2ca11756162605587da9187e0391c180c05b19ed')
