module Product
  # Layer 1. Pure product content — this is what would ship to `main`. No tooling chrome,
  # no floating controls. Reads a scenario param only to pick which seeded state to render;
  # it never generates state itself (SPEC-prototype-review-environment.md §1.5).
  class ScreensController < ApplicationController
    layout "product"

    def show
      @screen = ScreenCatalog.find!(params[:slug])
      @scenario = @screen.scenarios.fetch(params[:scenario]) { @screen.scenarios.fetch(@screen.default_scenario) }
      render template: "product/screens/#{@screen.slug}"
    end
  end
end
