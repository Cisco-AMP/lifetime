require "lifetime/version"

module Lifetime  
  extend ActiveSupport::Concern

  included do 
    @@lifetime_start_field = "start_at"
    @@lifetime_end_field = "end_at"

    scope :lifetime_active, ->(time = Time.now) { where(" ? <= ? AND ? >= ?", @@lifetime_start_field, time, @@lifetime_end_field, time).lifetime_ordered }
    scope :lifetime_inactive, ->(time = Time.now) { where(" ? > ? || AND ? < ?", @@lifetime_start_field, time, @@lifetime_end_field, time) }
    scope :lifetime_expired, ->(time = Time.now) { where(" ? < ?", @@lifetime_end_field, time).order(end_at: :desc) }
    scope :lifetime_future, ->(time = Time.now) { where(" ? > ?", @@lifetime_start_field, time).lifetime_ordered }
    scope :lifetime_ordered, -> {order(start_at: :asc)}
  end

  module ClassMethods    
    def lifetime_fields *args
      class_variable_set(:@@lifetime_start_field, args[0].to_s)
      class_variable_set(:@@lifetime_end_field, args[1].to_s)
    end
  end

  def lifetime_start_at
    send(@@lifetime_start_field)
  end

  def lifetime_end_at
    send(@@lifetime_end_field)
  end

  def lifetime_active?(time = Time.now)
    lifetime_start_at <= time && lifetime_end_at >= time
  end

  def lifetime_inactive?(time = Time.now)
    !lifetime_active?
  end

  def lifetime_expired?(time = Time.now)
    lifetime_end_at < time
  end
  
  def lifetime_future?(time = Time.now)
    lifetime_start_at > time
  end

  def lifetime_next_future(time = Time.now)
    self.class.lifetime_future(time).first
  end

  def lifetime_last_expired(time = Time.now)
    self.class.lifetime_expired(time).first
  end

  def lifetime_overlaps?(another)
    lifetime.overlaps? another.lifetime
  end

  def lifetime
    lifetime_start_at..lifetime_end_at
  end

end
