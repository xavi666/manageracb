# == Schema Information
#
# Table name: players
#
#

class Player < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  has_many :statistics
  belongs_to :team
  belongs_to :user_team_players
  has_many :predictions
  has_many :prices

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************

  # !**************************************************
  # !                  Other
  # !**************************************************
  include PlayerAllowed

  extend Enumerize
  enumerize :position, in: [:base, :alero, :pivot], predicates: true
  
  monetize :price_cents, allow_nil: true

  def to_s
    name
  end

  def print_price
    ActiveSupport::NumberHelper.number_to_delimited(price.to_i, :delimiter => ".")
  end

  def position_integer
    if self.position.base?
      -1 
    elsif self.position.alero?
      0 
    elsif self.position.pivot?
      1
    end 
  end

end