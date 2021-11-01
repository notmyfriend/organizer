class CommentsController < ApplicationController
  before_action :find_commentable, only: [:create, :destroy]
  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(content: params[:comment][:content], user_id: current_user.id)
    respond_to do |format|
      if @comment.save
        organization = find_organization

        format.html { redirect_to organization }
        format.js
      else
        format.js { render js: "alert('error saving comment')" }
      end
    end
  end

  def destroy
    return unless current_user.admin?

    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update(deleted: 'true')
        format.html { redirect_to find_organization }
        format.js
      else
        format.js { render js: "alert('error deleting comment (comment_id: #{@comment.id})')" }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_commentable
    if params[:comment_id]
      @commentable = Comment.find(params[:comment_id])
    elsif params[:organization_id]
      @commentable = Organization.find(params[:organization_id])
    end
  end

  def find_organization
    if @commentable.instance_of? Organization
      @commentable
    else
      comment = @commentable
      comment = Comment.find(comment.commentable_id) until comment.commentable_type == 'Organization'

      Organization.find(comment.commentable_id)
    end
  end
end
