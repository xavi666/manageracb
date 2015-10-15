# == Schema Information
#
# Table name: players
#
#

class Player < ActiveRecord::Base

  attr_accessible :name, :team_id

end