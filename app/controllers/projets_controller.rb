class ProjetsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_projet, only: [:show,:edit, :update, :destroy]
  before_action :set_outils, only: [:new, :edit, :create, :update]

  def index
    @projets = Projet.left_joins(:outils).distinct.order(date_debut: :desc)
    if params[:query].present?
      sql_subquery = <<-SQL
        projets.titre ILIKE :query OR
        projets.description ILIKE :query OR
        outils.description ILIKE :query
      SQL
      @projets = @projets.where(sql_subquery, query: "%#{params[:query]}%")
    end
  end

  def show
    if @projet.nil?
      # Gérer le cas où aucun article n'est trouvé avec le titre spécifié
      flash[:error] = "Aucun article trouvé avec le titre spécifié"
      redirect_to articles_path # Rediriger vers la liste des articles ou une autre page appropriée
    end
  end

  def new
    @projet = Projet.new
  end

  def create
    @projet = Projet.new(projet_params)
    if @projet.save
      flash[:notice] = "Projet créé avec succès"
      redirect_to projet_path(@projet)
    else
      flash[:error] = "Projet non créé, veuillez réessayer"
      render :new
    end
  end

  def edit
  end

  def update
    if @projet.update(projet_params)
      redirect_to projet_path(@projet), notice: "Projet modifié avec succès"
    else
      flash[:error] = "Projet non modifié, veuillez réessayer"
      render :edit
    end
  end


  def destroy
    if @projet.destroy
      flash[:notice] = "Projet supprimé avec succès"
      redirect_to projets_path, status: :see_other
    else
      flash[:error] = "Projet non supprimé, veuillez réessayer"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def projet_params
    params.require(:projet).permit(
      :titre,
      :type_projet,
      :description,
      :image_url,
      :image_url_alt,
      :date_debut,
      :date_fin,
      :client,
      :projet_lien,
      :github_lien,
      :couleur,
      outil_ids: []
    )
  end

  def set_projet
    @projet = Projet.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Projet non trouvé"
    redirect_to projets_path
  end

  def set_outils_projet
    @outils_projet = OutilsProjet.where(projet_id: @projet.id) if @projet.present? && OutilsProjet.find(@projet).present?
  end

  def set_outils
    @outils_projet = OutilsProjet.new
    @outils = Outil.all.order(:nom => :desc)
  end

end
