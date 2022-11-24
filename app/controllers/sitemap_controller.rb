class SitemapController < ApplicationController
# From https://makandracards.com/makandra/689-know-your-haml-comments
	SitemapController < ApplicationController
  layout nil
  def index
    headers['Content-Type'] = 'application/xml'
    respond_to do |format|
      format.xml {@articles = Article.all}
    end
  end

end
