# == Schema Information
#
# Table name: user_teams
#
#

class UserTeam < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  has_many :bases, foreign_key: 'player_id', class_name: 'UserTeamPlayer'
  has_many :aleros, foreign_key: 'player_id', class_name: 'UserTeamPlayer'
  has_many :pivots, foreign_key: 'player_id', class_name: 'UserTeamPlayer'

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************

  # !**************************************************
  # !                  Other
  # !**************************************************  
  accepts_nested_attributes_for :bases, :aleros, :pivots

end