class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:edit, :update, :destroy, :show]

  def index
    @articles = Article.all.order(created_at: :desc)
    @article_counts_by_theme = Article.count_by_theme
    if params[:theme].present?
      @articles = @articles.where(theme: params[:theme])
    end
  end

  def show
    if @article.nil?
      flash[:error] = "Aucun article trouvé avec le titre spécifié"
      redirect_to articles_path
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save!
      flash[:notice] = "Article créé avec succès"
      redirect_to article_detail_path(@article.titre.gsub(' ', '-'))
    else
      flash[:error] = "Article non créé, veuillez réessayer"
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to article_detail_path(@article.titre.gsub(' ', '-')), notice: "Article modifié avec succès"
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
      render :show, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:titre, :content, :image_url, :image_alt, :couleur, :theme)
  end

  def set_article
    @article = Article.friendly.find(params[:id])
  end
end
