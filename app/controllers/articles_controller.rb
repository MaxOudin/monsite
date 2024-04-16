class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.all
    if params[:query].present?
      # rich_text_ids = ActionText::RichText.where("body ILIKE :query", query: "%#{params[:query]}%").pluck(:record_id)
      # @articles = @articles.where("titre ILIKE :query OR id IN (?)", "%#{params[:query]}%", rich_text_ids)

      # sql_subquery = "titre ILIKE :query OR content.body ILIKE :query"
      # @articles = @articles.where(sql_subquery, query: "%#{params[:query]}%")
    end
  end

  def show
    titre = params[:id].gsub('-', ' ')
    @article = Article.find_by(titre: titre)
    if @article.nil?
      # Gérer le cas où aucun article n'est trouvé avec le titre spécifié
      flash[:error] = "Aucun article trouvé avec le titre spécifié"
      redirect_to articles_path # Rediriger vers la liste des articles ou une autre page appropriée
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
    @article = Article.find(params[:id])
  end
end
