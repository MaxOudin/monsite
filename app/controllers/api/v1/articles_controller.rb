class Api::V1::ArticlesController < Api::V1::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:index, :show]
  before_action :set_article, only: [:show, :update, :destroy]

  def index
    authorize Article, :index?
    @articles = policy_scope(Article)
  end

  def show
  end

  def create
    @article = Article.new(article_params)
    authorize @article
    if @article.save
      render :show, status: :created
    else
      render_error
    end
  end

  def update
    if @article.update(article_params)
      render :show
    else
      render_error
    end
  end

  def destroy
    @article.destroy
    head :no_content
  end

  private

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  def article_params
    params.require(:article).permit(:titre, :theme, :image_url, :image_alt, :content, :couleur)
  end

  def render_error
    render json: { errors: @article.errors.full_messages },
      status: :unprocessable_entity
  end
  
end