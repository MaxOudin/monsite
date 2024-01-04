class ProjetsController < ApplicationController

  def index
    @projets = Projet.all
  end
  
end
