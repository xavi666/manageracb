module PredictionAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def top_ten_value
      order(value: :desc).first(10)
    end

    def top_ten_points
      order(points: :desc).first(10)
    end
  end
end