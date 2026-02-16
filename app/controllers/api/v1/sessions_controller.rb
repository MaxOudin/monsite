class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  
  # Définir explicitement le mapping Devise
  before_action :set_devise_mapping

  # POST /api/v1/login
  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      # Générer les tokens
      tokens = generate_tokens(user)
      
      render json: {
        status: { code: 200, message: 'Connexion réussie' },
        data: {
          user: { id: user.id, email: user.email },
          tokens: tokens
        }
      }, status: :ok
    else
      # Notifie Rack::Attack pour les blocklists logins/ip/fail_l1 et fail_l2
      ActiveSupport::Notifications.publish(
        "rack.attack.login_failure",
        Time.current,
        Time.current,
        SecureRandom.uuid,
        { request: request }
      )
      render json: { error: 'Email ou mot de passe invalide' }, status: :unauthorized
    end
  end
  
  # POST /api/v1/refresh
  def refresh
    # Récupérer le refresh token
    refresh_token = request.headers['Authorization']&.split(' ')&.last || params[:refresh_token]
    
    unless refresh_token
      return render json: { error: 'Refresh token manquant' }, status: :unauthorized
    end
    
    begin
      # Décoder le token
      secret_key = ENV['DEVISE_JWT_SECRET_KEY']
      decoded_token = JWT.decode(refresh_token, secret_key, true, { algorithm: 'HS256' })
      
      # Vérifier que c'est un refresh token
      if decoded_token[0]['type'] != 'refresh'
        return render json: { error: 'Token invalide' }, status: :unauthorized
      end
      
      # Récupérer l'utilisateur
      user_id = decoded_token[0]['sub']
      user = User.find(user_id)
      
      # Générer de nouveaux tokens
      tokens = generate_tokens(user)
      
      render json: {
        status: { code: 200, message: 'Tokens rafraîchis' },
        data: { tokens: tokens }
      }, status: :ok
    rescue JWT::ExpiredSignature
      render json: { error: 'Refresh token expiré' }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: 'Token invalide' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Utilisateur non trouvé' }, status: :unauthorized
    end
  end
  
  # DELETE /api/v1/logout
  def destroy
    render json: { status: 200, message: 'Déconnexion réussie' }, status: :ok
  end

  private
  
  # Définir le mapping Devise pour ce contrôleur
  def set_devise_mapping
    request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  def generate_tokens(user)
    secret_key = ENV['DEVISE_JWT_SECRET_KEY']
    
    # Token d'accès (1 heure)
    access_payload = {
      sub: user.id,
      email: user.email,
      exp: 1.hour.from_now.to_i,
      iat: Time.current.to_i,
      jti: SecureRandom.uuid,
      type: 'access'
    }
    
    # Token de rafraîchissement (1 semaine)
    refresh_payload = {
      sub: user.id,
      exp: 1.week.from_now.to_i,
      iat: Time.current.to_i,
      jti: SecureRandom.uuid,
      type: 'refresh'
    }
    
    {
      access_token: JWT.encode(access_payload, secret_key, 'HS256'),
      refresh_token: JWT.encode(refresh_payload, secret_key, 'HS256')
    }
  end
end 