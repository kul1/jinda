class CommentsController < ApplicationController

  def create
    @article = Article.find(article_params["article_id"])
    @comment = @article.comments.new(comment_params)
    @comment.save!
    redirect_to controller: 'articles', action: 'show', article_id: @article
  end

  private

  def article_params
    params.require(:comment).permit(:article_id)
  end

  def comment_params
    params.require(:comment).permit(:body, :article_id, :user_id)
  end
end
