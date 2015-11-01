module StatisticAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def game
      where(type_statistic: "game")
    end

    def team
      where(type_statistic: "team")
    end

    def player
      where(type_statistic: "player")
    end
  end
end