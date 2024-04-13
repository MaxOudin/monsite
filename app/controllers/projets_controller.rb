class ProjetsController < ApplicationController

  def index
    @projets = Projet.all
  end

  def show
    titre = params[:id].gsub('-', ' ')
    @projet = Projet.find_by(titre: titre)
  end

  private

  def projet_params
    params.require(:projet).permit(:titre, :description, :image)
  end
end
