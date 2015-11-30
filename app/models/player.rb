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
end