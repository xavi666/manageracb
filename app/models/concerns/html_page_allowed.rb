module HtmlPageAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def game
      where(html_page_type: "game")
    end

    def statistic
      where(html_page_type: "statistic")
    end
  end
end