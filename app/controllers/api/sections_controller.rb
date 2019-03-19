class Api::SectionsController < Api::BaseController
  before_action :set_section, only: %i[update destroy]

  # GET /api/sections
  def index
    @sections = Section.select(Section::INDEX_ATTRIBUTES).roots.order(id: :desc)
    @pagy, @sections = pagy(@sections, items: 30, page: params[:page] || 1)

    render 'api/sections/index.json.jbuilder'
  end

  # GET /api/sections/all
  def all
    @sections = Section.select(Section::INDEX_ATTRIBUTES)
                       .roots

    render 'api/sections/all.json.jbuilder'
  end

  # GET /api/sections/all_visible
  def all_visible
    @sections = Section.select(Section::INDEX_ATTRIBUTES)
                    .includes(:children)
                    .roots.is_display?

    render 'api/sections/all_visible.json.jbuilder'
  end

  # POST /api/sections
  def create
    begin
      @section = SectionService.create(section_params, params[:child_section_ids])

      data = @section.as_json(only: Section::INDEX_ATTRIBUTES)
      msg = I18n.t('crud.create_successfully', class_name: I18n.t('section.class_name'), title: @section.title_with_parent)

      render_success_json data, msg
    rescue Exception => e
      render_error_json e.message
    end
  end

  # PATCH/PUT /api/sections/1
  def update
    begin
      section = SectionService.update(@section, section_params, params[:child_section_ids])

      data = section.as_json(only: Section::INDEX_ATTRIBUTES)
      msg = I18n.t('crud.update_successfully', class_name: I18n.t('section.class_name'), title: section.title_with_parent)

      render_success_json data, msg
    rescue Exception => e
      render_error_json e.message
    end
  end

  # DELETE /api/sections/1
  def destroy
    @section.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_section
    @section = Section.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def section_params
    params.permit(Section::UPDATABLE_ATTRIBUTES)
  end
end
