class EntryIndicatorsController < ApplicationController
  before_action :set_entry_indicator, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:index, :show]

  def index
    if params[:organization_id] && params[:period]
#     organization_id = params[:organization_id].nil? ? current_user.organizations.take.id : params[:organization_id]
      @organization = Organization.find(params[:organization_id])
      @organization_type = @organization.organization_type
      @period = Period.find(params[:period])
      @units = @organization.units.order(:order).to_a
      @main_processes = MainProcess.where(period_id: @period.id).order(:order)
      if params[:unit]
        @unit = Unit.find(params[:unit])
      else
        @unit = @units.first
      end
      @official_groups = OfficialGroup.all
      if @main_processes.empty?
        render :index, notice: t("entry_indicators.flash.no_main_processes")
      end
    end
  end

  def new
    @entry_indicator = EntryIndicator.new
  end

  def create
    @entry_indicator = EntryIndicator.new(entry_indicator_params)

    if @entry_indicator.save
      redirect_to @entry_indicator, notice: 'Entry indicator was successfully created.'
    else
      render :new
    end
  end

  def update
    if @entry_indicator.update(entry_indicator_params)
      redirect_to @entry_indicator, notice: 'Entry indicator was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @entry_indicator.destroy
    redirect_to entry_indicators_url, notice: 'Entry indicator was successfully destroyed.'
  end

  private

    def set_entry_indicator
      @entry_indicator = EntryIndicator.find(params[:id])
    end

    def entry_indicator_params
      params.fetch(:entry_indicator, {})
    end

    def organizations_select_options
      current_user.auth_organizations.collect { |v| [ v.description, v.id ] }
     end

    def organization_types_select_options
      current_user.auth_organization_types.collect { |v| [ v.description, v.id ] }
    end

    def periods_select_options
      @periods ||= Period.where(organization_type_id: @organization_type_id).order(:started_at)
      @periods.collect { |v| [ v.description, v.id ] }
    end

end
