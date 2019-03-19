class Api::RolesController < Api::BaseController
  before_action :set_role, only: %i[update]

  # GET /api/roles
  def index
    @roles = Role.order(id: :desc)
    @pagy, @roles = pagy(@roles, items: 30, page: params[:page] || 1)

    render 'api/roles/index.json.jbuilder'
  end

  # GET /api/roles/all
  def all
    @roles = Role.select(Role::INDEX_ATTRIBUTES).all

    render json: @roles.as_json(only: Role::INDEX_ATTRIBUTES)
  end

  # GET /api/roles/my_role
  def my_role
    @role = Role.find(User.current_user.role_id)

    render 'api/roles/my_role.json.jbuilder'
  end

  # POST /api/roles
  def create
    begin
      @role = RoleService.create(role_params, params[:section_ids], params[:is_admin], configs_params)

      data = @role.as_json(only: Role::INDEX_ATTRIBUTES)
      msg = I18n.t('crud.create_successfully', class_name: I18n.t('role.class_name'), title: @role.title)

      render_success_json data, msg
    rescue Exception => e
      render_error_json e.message
    end
  end

  # PATCH/PUT /api/roles/1
  def update
    begin
      role = RoleService.update(@role, role_params, params[:section_ids], params[:is_admin], configs_params)

      data = role.as_json(only: Role::INDEX_ATTRIBUTES)
      msg = I18n.t('crud.update_successfully', class_name: I18n.t('role.class_name'), title: role.title)

      render_success_json data, msg
    rescue Exception => e
      render_error_json e.message
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def role_params
    params.permit(Role::UPDATABLE_ATTRIBUTES)
  end

  def configs_params
    configs = []

    if params[:can_access_landlord_information]
      configs << ConfigModel.new({type: ConfigModel::TYPE_LESSOR, value: 1 })
    end

    if params[:can_access_company_properties]
      configs << ConfigModel.new({type: ConfigModel::TYPE_LESSEE, value: 1 })
    end

    configs
  end
end
