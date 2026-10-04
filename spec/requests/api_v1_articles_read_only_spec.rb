# frozen_string_literal: true

require "rails_helper"

RSpec.describe "API articles lecture seule", type: :request do
  let!(:article) { create(:article) }

  it "autorise GET index" do
    get api_v1_articles_path
    expect(response).to have_http_status(:ok)
  end

  it "autorise GET show" do
    get api_v1_article_path(article)
    expect(response).to have_http_status(:ok)
  end

  it "n'expose pas POST create" do
    expect do
      Rails.application.routes.recognize_path("/api/v1/articles", method: :post)
    end.to raise_error(ActionController::RoutingError)
  end

  it "n'expose pas PATCH update" do
    expect do
      Rails.application.routes.recognize_path("/api/v1/articles/#{article.id}", method: :patch)
    end.to raise_error(ActionController::RoutingError)
  end

  it "n'expose pas DELETE destroy" do
    expect do
      Rails.application.routes.recognize_path("/api/v1/articles/#{article.id}", method: :delete)
    end.to raise_error(ActionController::RoutingError)
  end
end
