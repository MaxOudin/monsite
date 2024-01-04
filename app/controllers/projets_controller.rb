class ProjetsController < ApplicationController

  def index
    @projets = Projet.all
  end

  def show
    @projet = Projet.find(params[:id])
  end


end
