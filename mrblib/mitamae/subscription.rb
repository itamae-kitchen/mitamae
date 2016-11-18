module MItamae
  class Subscription < Notification
    def action_resource
      defined_in_resource
    end
  end
end
