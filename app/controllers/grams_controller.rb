class GramsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :ensure_gram_found!, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)

    if @gram.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    current_gram.update_attributes(gram_params)

    if current_gram.valid?
      return redirect_to root_url
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_gram.destroy

    return redirect_to root_url
  end

  private

  def gram_params
    params.require(:gram).permit(:message)
  end

  def current_gram
    @current_gram ||= Gram.find_by_id(params[:id])
  end

  def ensure_gram_found!
    if current_gram.blank?
      return render file: 'public/404.html', status: :not_found
    end
  end

end
