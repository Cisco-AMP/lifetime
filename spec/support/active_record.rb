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

ActiveRecord::Schema.define :version => 0 do
  create_table :meetings, :force => true do |t|
    t.string   :name
    t.datetime :start_at
    t.datetime :end_at
  end
end

ActiveRecord::Schema.define :version => 0 do
  create_table :exams, :force => true do |t|
    t.string   :name
    t.datetime :exam_start_at
    t.datetime :exam_end_at
  end
end

class Meeting < ActiveRecord::Base
  include Lifetime
end

class License < ActiveRecord::Base
  include Lifetime
  lifetime_fields :start_date, :end_date
end

class Exam < ActiveRecord::Base
  include Lifetime
  lifetime_fields :exam_start_at, :exam_end_at
end



