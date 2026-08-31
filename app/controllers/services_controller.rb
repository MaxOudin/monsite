class ServicesController < ApplicationController
  def index
    @services = Service.all
    @years_of_experience = Date.current.year - 2023
    @projets_count = Projet.count
    @articles_count = Article.count
  end
end

