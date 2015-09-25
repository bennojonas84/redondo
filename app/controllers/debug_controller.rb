class DebugController < ApplicationController
  def rails_log
    # if Rails.env == 'staging'
      txt = `tail -n 10000 #{Rails.root}/log/#{Rails.env}.log`
      render text: "<html><body><h1>Rails Log</h1><pre>#{txt}</pre></body></html>"
    # end
  end
end
