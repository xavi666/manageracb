# == Schema Information
#
# Table name: games
#
#

class Game < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************
  has_many :statistics
  belongs_to :local_team, class_name: "Team", foreign_key: 'local_team_id'
  belongs_to :visitant_team, class_name: "Team", foreign_key: 'visitant_team_id'  
  has_one :prediction

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************

  # !**************************************************
  # !                  Other
  # !**************************************************


end