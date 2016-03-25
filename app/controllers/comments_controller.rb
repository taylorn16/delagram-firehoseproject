class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_gram_exists, only: [:create, :destroy]
  before_action :check_comment_exists, only: [:destroy]
  before_action :authorize_current_comment, only: [:destroy]

  def create
    @comment = current_gram.comments.create(comment_params)

    if @comment.valid?
      return redirect_to root_url
    else

    end
  end

  def destroy
    current_comment.destroy

    return redirect_to root_url
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def current_gram
    @current_gram ||= Gram.find_by_id(params[:gram_id])
  end

  def current_comment
    @current_comment ||= Comment.find_by_id(params[:id])
  end

  def check_gram_exists
    if current_gram.nil?
      return render file: 'public/404.html', status: :not_found
    end
  end

  def check_comment_exists
    if current_comment.nil?
      return render file: 'public/404.html', status: :not_found
    end
  end

  def authorize_current_comment
    unless current_comment.user == current_user
      return render file: 'public/422.html', status: :forbidden
    end
  end

end
