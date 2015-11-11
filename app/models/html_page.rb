# == Schema Information
#
# Table name: html_pages
#
#

class HtmlPage < ActiveRecord::Base
  # !**************************************************
  # !                Associations
  # !**************************************************

  # !**************************************************
  # !                Validations
  # !**************************************************

  # !**************************************************
  # !                Callbacks
  # !**************************************************

  # !**************************************************
  # !                  Other
  # !**************************************************
  include HtmlPageAllowed
  extend Enumerize

  enumerize :html_page_type, in: [:statistic, :game]

end