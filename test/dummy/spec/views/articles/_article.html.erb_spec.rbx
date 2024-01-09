let login_as_admin

describe 'articles/_article.html.erb' do
	context 'when the article has a url' do
	it 'display the url' do
			assign(:article, Article.build(:article, url: 'http://localhost:3000/jinda/init?s=articles:new_article'))

						 render

						 expect(rendered).to have_link 'Article', href: 'http://localhost:3000/jinda/init?s=articles:new_article'
		end
	end
end

