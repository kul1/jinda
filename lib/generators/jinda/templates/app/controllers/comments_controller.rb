class CommentsController < ApplicationController

  def create
    # $xvars['p'] is the query parameters like params in rails guide:
    # private
    # def comment_params
    #   params.require(:comment).permit(:commenter, :body)
    # end
    #
    @article = Article.find($xvars['p']['comment']['article_id'])
    @comment = @article.comments.new(
                      body: $xvars['p']['comment']['body'],
                      user_id: $xvars["user_id"])
    @comment.save!
  end

end
