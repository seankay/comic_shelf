module Spree
  User.class_eval do
    belongs_to :store

    def set_roles(roles)
      roles.each do |r|
        spree_roles << Spree::Role.find_or_create_by_name(r.to_s)
      end
    end

    def has_role? role
      spree_roles.each do |r|
        return true if r.name.eql?(role.to_s)
      end
      false
    end
  end
end
