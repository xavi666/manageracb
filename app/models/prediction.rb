# == Schema Information
#
# Table name: games
#
#

class Prediction < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  belongs_to :game
  belongs_to :player

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************
  before_update :update_price, :if => :value_changed?

  # !**************************************************
  # !                  Other
  # !**************************************************
  extend Enumerize
  monetize :price_cents, allow_nil: true
  include Enumerable

  def update_price
    price = Price.where(season: self.game.season, player_id: self.player_id, game_number: self.game.game_number - 1).first
    price = Price.where(season: self.game.season, player_id: self.player_id, game_number: self.game.game_number).first unless price
    if price
      statistic = Statistic.player.where(player_id: self.player_id, season: self.game.season, game_number: self.game.game_number - 1).first
      self.price_cents = (statistic.value + self.value) / self.game.game_number * 70000 * 100
    end
  end

  def print_price
    ActiveSupport::NumberHelper.number_to_delimited(price.to_i, :delimiter => ".")
  end

end