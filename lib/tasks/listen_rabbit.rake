require 'judge'

namespace :zmora do
  desc 'Start listening for tasks results'
  task listen_rabbit: :environment do
    Judge.start_receive_results true
  end
end
