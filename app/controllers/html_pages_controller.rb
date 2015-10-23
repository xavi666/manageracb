class HtmlPagesController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

  def index
    @html_pages = HtmlPage.all
  end

  def create
    @html_page = HtmlPage.create(html_page_params)
  end

  def update
    @html_page.update_attributes html_pages_params
  end

  def destroy
    @html_page.destroy
  end

  def import
    cod_edicions = ["59"]
    @count = 0
    cod_edicions.each_with_index {|cod_edicion, index| 
      #totals partits => 9 * 34 = 306

      (1..306).each do |partit|
        url_partit = "http://www.acb.com/stspartido.php?cod_competicion=LACB&cod_edicion=59&partido="+partit.to_s
        pagina_partit = Nokogiri::HTML(open(url_partit))
        HtmlPage.create!(:code => cod_edicion, :game_number => partit, :html => pagina_partit.inner_html)
        @count += 1
      end
    }
  end

  private
    def html_page_params
      params.require(:html_page).permit([:game_number])
    end

end
