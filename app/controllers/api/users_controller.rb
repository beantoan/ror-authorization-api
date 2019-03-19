class Api::UsersController < Api::BaseController
  before_action :set_user, only: %i[update]

  # GET /api/users
  def index
    @users = User.includes(:role)
                 .select(User::INDEX_ATTRIBUTES)
                 .order(id: :desc)
    @pagy, @users = pagy(@users, items: 30, page: params[:page] || 1)

    render 'api/users/index.json.jbuilder'
  end

  # GET /api/users/all
  def all
    @users = User.select(User::INDEX_ATTRIBUTES)

    render 'api/users/all.json.jbuilder'
  end

  # POST /api/users
  def create
    begin
      @user = UserService.create(user_params)

      data = @user.as_json(only: User::INDEX_ATTRIBUTES)
      msg = I18n.t('crud.create_successfully', class_name: I18n.t('user.class_name'), title: @user.name)

      render_success_json data, msg
    rescue Exception => e
      render_error_json e.message
    end
  end

  # PATCH/PUT /api/users/1
  def update
    begin
      user = UserService.update(@user, user_params)

      data = user.as_json(only: User::INDEX_ATTRIBUTES)
      msg = I18n.t('crud.update_successfully', class_name: I18n.t('user.class_name'), title: user.name)

      render_success_json data, msg
    rescue Exception => e
      render_error_json e.message
    end
  end

  # GET /api/users/statuses
  def statuses
    statuses = User.statuses_i18n.map { |value, name| { id: value, name: name } }

    render json: statuses
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(User::UPDATABLE_ATTRIBUTES)
  end
end
