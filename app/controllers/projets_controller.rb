class ProjetsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_projet, only: %i[show edit update destroy]
  before_action :set_outils, only: %i[new edit create update]

  def index
    @projets = policy_scope(Projet).order(date_debut: :desc)
    @projets = @projets.search_projets(params[:query]) if params[:query].present?
  end

  def show
  end

  def new
    @projet = Projet.new
    authorize @projet
  end

  def create
    @projet = Projet.new(projet_params)
    authorize @projet
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
    authorize @projet
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Projet non trouvé"
    redirect_to projets_path
  end

  def set_outils_projet
    @outils_projet = OutilsProjet.where(projet_id: @projet.id) if @projet.present? && OutilsProjet.find(@projet).present?
  end

  def set_outils
    @outils_projet = OutilsProjet.new
    @outils = Outil.all.order(:nom => :asc)
  end

end
