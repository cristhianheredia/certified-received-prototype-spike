# Layer 2. The review/tooling wrapper: catalog index + the page that floats the controls
# around an iframed Layer 1 screen. This controller (and its views/layout) is the thing that
# must stay out of a real `main` deploy later (SPEC-prototype-review-environment.md §2).
class ScreensController < ApplicationController
  layout "tooling"

  def index
    @screens = ScreenCatalog::SCREENS.values
  end

  def show
    @screen = ScreenCatalog.find!(params[:slug])
    @scenario_slug = params[:scenario].presence || @screen.default_scenario
    @scenario = @screen.scenarios.fetch(@scenario_slug)
  end
end
