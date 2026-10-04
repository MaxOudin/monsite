class ArticlesController < ApplicationController
  include Searchable

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, only: %i[edit update destroy show]

  def index
    @articles = policy_scope(Article).order(created_at: :desc)
    query = active_search_query
    @articles = @articles.search_articles(query) if query
  end

  def show
    return unless @article

    @related_articles = @article.related_articles
  end

  def new
    @article = Article.new
    authorize @article
  end

  def edit; end

  def create
    @article = Article.new(article_params)
    authorize @article
    if @article.save
      flash[:notice] = "Article créé avec succès"
      redirect_to article_path(@article), notice: "Article créé avec succès"
    else
      flash[:error] = "Article non créé, veuillez réessayer"
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to article_path(@article), notice: "Article modifié avec succès"
    else
      flash[:error] = "Article non modifié, veuillez réessayer"
      render :edit
    end
  end

  def destroy
    if @article.destroy
      flash[:notice] = "Article supprimé avec succès"
      redirect_to articles_path, status: :see_other
    else
      flash[:error] = "Article non supprimé, veuillez réessayer"
      render :show, status: :unprocessable_content
    end
  end

  private

  def article_params
    params.require(:article).permit(:titre, :content, :image_url, :image_alt, :couleur, :theme)
  end

  def set_article
    @article = Article.friendly.find(params[:id])
    authorize @article
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Aucun article trouvé avec le titre spécifié"
    redirect_to articles_path
  end
end
