module Spree
  module Preferences
    Configuration.class_eval do
      def preference_cache_key name
        if ::Store.table_exists? && !(current_store = ::Store.current_store).nil?
          [current_store.id, self.class.name, name].join('::').underscore
        else
          [self.class.name, name].join('::').underscore
        end
      end
    end
  end
end
