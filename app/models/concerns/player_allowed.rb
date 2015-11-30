module PlayerAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def active
      where(active: true)
    end
    def bases
      where(position: "base")
    end
    def aleros
      where(position: "alero")
    end
    def pivots
      where(position: "pivot")
    end
  end
end