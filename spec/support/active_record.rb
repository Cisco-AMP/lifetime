require 'active_record'
require 'logger'

unless ENV['DB']
  ENV['DB'] = 'sqlite'
end

ActiveRecord::Base.logger = Logger.new('tmp/ar_debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('spec/support/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'].to_sym)

ActiveRecord::Schema.define :version => 0 do
  create_table :licenses, :force => true do |t|
    t.string   :name
    t.datetime :start_date
    t.datetime :end_date
  end
end

class License < ActiveRecord::Base
  include Lifetime
  lifetime_fields :start_date, :end_date
end
