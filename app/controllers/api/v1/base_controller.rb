# app/controllers/api/v1/base_controller.rb
class Api::V1::BaseController < ActionController::API
  include Pundit::Authorization
  include ActionController::MimeResponds
  
  respond_to :json
  
  before_action :authenticate_user_from_token!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWT::ExpiredSignature, with: :token_expired

  private

  def authenticate_user_from_token!
    # Ignorer l'authentification pour le contrôleur de sessions
    return if request.controller_class.to_s == 'Api::V1::SessionsController'

    # Vérifier la présence d'un token
    token = request.headers['Authorization']&.split(' ')&.last
    unless token
      render json: { error: "Non authentifié" }, status: :unauthorized
      return
    end

    begin
      # Décoder le token
      secret_key = ENV['DEVISE_JWT_SECRET_KEY']
      decoded_token = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
      
      # Vérifier que c'est un token d'accès
      if decoded_token[0]['type'] != 'access'
        render json: { error: "Type de token invalide" }, status: :unauthorized
        return
      end
      
      # Authentifier l'utilisateur
      user_id = decoded_token[0]['sub']
      @current_user = User.find(user_id)
      sign_in @current_user, store: false
    rescue JWT::ExpiredSignature
      render json: { error: "Token expiré" }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: "Token invalide" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Utilisateur non trouvé" }, status: :unauthorized
    end
  end

  def token_expired
    render json: { error: "Token expiré" }, status: :unauthorized
  end

  def user_not_authorized(exception)
    render json: { error: "Accès non autorisé" }, status: :unauthorized
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end