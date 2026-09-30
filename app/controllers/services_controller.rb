class ServicesController < ApplicationController
  def index
    @services = Service.all
    @years_of_experience = Date.current.year - 2023
    @projets_count = Projet.count
    @articles_count = Article.count
    @featured_projets = policy_scope(Projet).ordered.limit(3)
  end
end

