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

  def players
    players = []
    bases.each do |user_team_player|
      puts user_team_player.inspect
      players << user_team_player.player
    end
    aleros.each do |player|
      players << user_team_player.player
    end
    pivots.each do |player|
      players << user_team_player.player
    end
    players
  end

end