class HistoriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # GET /histories or /histories.json
  def index
    @histories = History.all.reverse_order
  end

  # POST /histories or /histories.json
  def create
    @history = History.new(history_params)
    @history.save
  end

  private

    # Only allow a list of trusted parameters through.
    def history_params
      params.permit(:topic, :difficulty, :questions, :results)
    end
end
