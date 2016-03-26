class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_gram_exists
  before_action :check_comment_exists, except: [:create]
  before_action :authorize_current_comment, except: [:create]

  def create
    @comment = current_gram.comments.create(comment_params.merge(user: current_user))

    if @comment.valid?
      return redirect_to root_url
    else
      return render 'grams/index', status: :unprocessable_entity
    end
  end

  def destroy
    current_comment.destroy

    return redirect_to root_url
  end

  def update
    current_comment.update_attributes(comment_params)

    return redirect_to root_url
  end

  def edit
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  helper_method :current_gram
  def current_gram
    @current_gram ||= Gram.find_by_id(params[:gram_id])
  end

  helper_method :current_comment
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
