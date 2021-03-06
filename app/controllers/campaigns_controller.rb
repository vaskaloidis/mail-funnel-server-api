class CampaignsController < ApplicationController
	before_action :set_campaign, only: [:show, :update, :destroy]

	# GET /campaigns
	def index
		if params.has_key?(:app_id)
			if params.has_key?(:name)
				@campaigns = Campaign.where(name: params[:name], app_id: params[:app_id])
			else
				@campaigns = Campaign.where(app_id: params[:app_id])
			end
		elsif params.has_key?(:campaign_id)
			@campaigns = Campaign.where(campaign_id: params[:campaign_id])
		else
			return 'You need to pass an app_id'
		end

		render json: @campaigns
	end

	# GET /campaigns/1
	def show
		@campaigns = Campaign.find(params[:id])
		render json: @campaign
	end

	# POST /campaigns
	def create
		@campaign = Campaign.new(campaign_params)

		if @campaign.save
			render json: @campaign, status: :created, location: @campaign
		else
			render json: @campaign.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /campaigns/1
	def update
		if @campaign.update(campaign_params)
			render json: @campaign
		else
			render json: @campaign.errors, status: :unprocessable_entity
		end
	end

	# DELETE /campaigns/1
	def destroy
		@campaign.destroy
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_campaign
		@campaign = Campaign.find(params[:id])
	end

	def campaign_params
		params.require(:campaign).permit(:hook_id, :name, :hook_identifier, :app_id, :email_list_id)
	end
end
