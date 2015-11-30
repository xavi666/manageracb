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

  def update_price
    puts "---------> UPDATE PRICE"
    price = Price.where(season: self.game.season, player_id: self.player_id, game_number: self.game.game_number - 1).first
    statistic = Statistic.player.where(season: self.game.season, game_number: self.game.game_number - 1).first
    puts statistic.value
    puts self.value
    puts self.game.game_number
    self.price = (statistic.value + self.value) / self.game.game_number * 70000 * 100
  end

end