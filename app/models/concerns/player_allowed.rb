module PlayerAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def active
      where(active: true)
    end
  end
end