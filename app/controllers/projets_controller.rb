class ProjetsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_projet, only: [:edit, :update, :destroy]

  def index
    @projets = Projet.all
    if params[:query].present?
      sql_subquery = "titre ILIKE :query OR description ILIKE :query"
      @projets = @projets.where(sql_subquery, query: "%#{params[:query]}%")
    end
  end

  def show
    titre = params[:id].gsub('-', ' ')
    @projet = Projet.find_by(titre: titre)
  end

  def new
    @projet = Projet.new
  end

  def create
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
    params.require(:projet).permit(:titre, :type_projet, :description, :image_url, :image_url_alt, :date_debut, :date_fin, :client, :projet_lien, :github_lien, :couleur)
  end

  def set_projet
    @projet = Projet.find(params[:id])
  end
end
