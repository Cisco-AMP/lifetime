require "lifetime/version"
require "active_support"

module Lifetime  
  extend ActiveSupport::Concern

  module ClassMethods 
    attr_accessor :lifetime_start_field, :lifetime_end_field   
    def lifetime_fields *args
      self.lifetime_start_field = args[0].to_s
      self.lifetime_end_field = args[1].to_s
    end
  end

  included do 
    self.lifetime_start_field = "start_at"
    self.lifetime_end_field = "end_at"
    scope :lifetime_active, ->(time = Time.now) { where(" #{lifetime_start_field} <= ? AND #{lifetime_end_field} >= ?", time, time).lifetime_ordered }
    scope :lifetime_inactive, ->(time = Time.now) { where(" #{lifetime_start_field} > ? OR #{lifetime_end_field} < ?", time, time) }
    scope :lifetime_expired, ->(time = Time.now) { where(" #{lifetime_end_field} < ?", time).order("#{lifetime_end_field} desc") }
    scope :lifetime_future, ->(time = Time.now) { where(" #{lifetime_start_field} > ?", time).lifetime_ordered }
    scope :lifetime_ordered, -> {order("#{lifetime_start_field} asc")}
  end

  def lifetime_start_at
    send(self.class.lifetime_start_field)
  end

  def lifetime_end_at
    send(self.class.lifetime_end_field)
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
