Deface::Override.new(:virtual_path => "spree/shared/_header",
                     :name => "store_name",
                     :replace => "#logo",
                     :partial => "shared/store_name_logo",
                     :disabled => false)
