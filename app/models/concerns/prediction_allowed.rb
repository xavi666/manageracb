module PredictionAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def top_ten_value
      where("games.season = ?", Setting.find_by_name("season").value).where("games.game_number = ?", Setting.find_by_name("game_number").value).order("predictions.value DESC").first(10)
    end

    def top_ten_points
      where("games.season = ?", Setting.find_by_name("season").value).where("games.game_number = ?", Setting.find_by_name("game_number").value).order("predictions.points DESC").first(10)
    end
  end
end