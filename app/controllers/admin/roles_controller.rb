class Admin::RolesController < Admin::BaseController
  before_action :set_resource, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @roles = @site ? @site.roles.order('id') : Role.where(site_id: nil).order('id')
    @rights = Weby::Rights.permissions.sort

    if request.put? # && params[:role]
      params[:role] ||= {}

      @roles.each do |role| # params[:role].each do |role, right|
        role.update(permissions: params[:role][role.id.to_s] ? params[:role][role.id.to_s]['permissions'].to_s : '{}')
      end

      flash[:success] = t('successfully_updated')
      redirect_to @site ? site_admin_roles_path : admin_roles_path
    end
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    @role.save

    record_activity('created_global_role', @role)

    redirect_to @site ? site_admin_roles_path : admin_roles_path
  end

  def edit
  end

  def update
    @role.update(role_params)

    record_activity('updated_global_role', @role)

    redirect_to @site ? site_admin_roles_path : admin_roles_path
  end

  def destroy
    @role.destroy

    record_activity('destroyed_global_role', @role)

    redirect_to :back
  end

  private

  def set_resource
    resource
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
