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
  monetize :price_cents, allow_nil: true
  enumerize :position, in: [:base, :alero, :pivot], predicates: true

  def to_s
    name
  end
end