class CommentsController < ApplicationController
  before_action :comment_params, only: [:create]
  before_action :load_commmentable

  def index
    @comments = @commentable.comments 
  end

  def create
    @comment = @commentable.comments.new comment_params
    @comment.save!
    redirect_to [@commentable], notice: "Comment created"
  end

  private

  # def article_params
  #   params.require(:comment).permit(:article_id)
  # end

  def comment_params
    resource = request.path.split('/')[1]                                
    commentable_id = "#{resource.singularize.to_sym}_id" #:article_id
    params.require(:comment).permit(:body, :user_id,:name, :image, commentable_id.to_sym)
  end

  def load_commmentable                                                        
    resource, id = request.path.split('/')[1,2]                                
    @commentable = resource.singularize.classify.constantize.find(id)          
  end     
end
