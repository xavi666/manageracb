# == Schema Information
#
# Table name: teams
#
#

class Statistic < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  belongs_to :player
  belongs_to :team, class_name: "Team", foreign_key: 'team_id'
  belongs_to :team_against, class_name: "Team", foreign_key: 'team_against_id'

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************
  before_save :set_nil_to_zero

  # !**************************************************
  # !                  Other
  # !**************************************************
  include StatisticAllowed
  extend Enumerize
  enumerize :type_statistic, in: [:game, :player, :team], predicates: true
  #default_scope { order('game_number ASC') } 
  scope :find_season, -> (season) { where(:season => season) }
  scope :find_game_number, -> (game_number) { where(:game_number => game_number) }

  private

    def set_nil_to_zero
      self.points = 0 if points.nil?
      self.two_p = 0 if two_p.nil?
      self.two_pm = 0 if two_pm.nil?
      self.three_p = 0 if three_p.nil?
      self.three_pm = 0 if three_pm.nil?
      self.one_p = 0 if one_p.nil?
      self.one_pm = 0 if one_pm.nil?
      self.rebounds = 0 if rebounds.nil?
      self.orebounds = 0 if orebounds.nil?
      self.drebounds = 0 if drebounds.nil?
      self.assists = 0 if assists.nil?
      self.steals = 0 if steals.nil?
      self.turnovers = 0 if turnovers.nil?
      self.fastbreaks = 0 if fastbreaks.nil?
      self.mblocks = 0 if mblocks.nil?
      self.rblocks = 0 if rblocks.nil?
      self.mfaults = 0 if mfaults.nil?
      self.rfaults = 0 if rfaults.nil?
      self.positive_negative = 0 if positive_negative.nil?
      self.value = 0 if value.nil?
    end

end