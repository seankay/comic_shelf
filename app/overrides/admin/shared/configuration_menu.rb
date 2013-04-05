Deface::Override.new(
  :virtual_path  => "spree/admin/shared/_configuration_menu",
  :name => "configuration_menu",
  :insert_bottom => "nav.menu > ul.sidebar",
  :text          => "<%= configurations_sidebar_menu_item t(:subscription), main_app.store_plans_path(current_store) %>"
)
