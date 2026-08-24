class Api::V1::ArticlesController < Api::V1::BaseController
  skip_before_action :authenticate_user_from_token!, only: %i[index show]
  before_action :set_article, only: %i[show]

  def index
    authorize Article, :index?
    @articles = policy_scope(Article)
  end

  def show
  end

  private

  def set_article
    @article = Article.friendly.find(params[:id])
    authorize @article
  end
end
