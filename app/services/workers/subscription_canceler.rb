module Workers
  class SubscriptionCanceler
    @queue = :subscription

    def self.perform id, options={}
      subscription = Subscription.find(id)
      #TODO: mail cancellation notice
      #TODO: disable store/site
      #TODO: dump/store pg:schema?
      subscription.save!
    end
  end
end
