class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_gram_exists, only: [:create]

  def create
    @comment = current_gram.comments.create(comment_params)

    if @comment.valid?
      return redirect_to root_url
    else

    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def current_gram
    @current_gram ||= Gram.find_by_id(params[:gram_id])
  end

  def check_gram_exists
    if current_gram.nil?
      return render file: 'public/404.html', status: :not_found
    end
  end

end
