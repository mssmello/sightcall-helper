# The demo controller simply demonstrates how to render some pages.  No layouts.

class DemoController < ApplicationController

  skip_before_filter :authorize

  def plain
    render :layout => false
  end

  def lightbox
    render :layout => false
  end

end
