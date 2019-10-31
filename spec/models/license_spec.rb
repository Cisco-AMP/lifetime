require 'spec_helper'

RSpec.describe License do 
  let(:five_days_ago)             {  Time.now - 5.days }
  let(:five_days_after)           { Time.now + 5.days }
  let(:ten_days_ago)              {  Time.now - 10.days }
  let(:ten_days_after)            { Time.now + 10.days }
  let(:twenty_days_after)         { Time.now + 20.days }
  let(:active_license)            { License.create(name: 'Active license', start_date: five_days_ago, end_date: five_days_after) }
  let(:expired_license)           { License.create(name: 'Expired license', start_date: ten_days_ago, end_date: five_days_ago) }
  let(:future_license)            { License.create(name: 'Future license', start_date: five_days_after, end_date: ten_days_after) }
  let(:another_future_license)    { License.create(name: 'Future license', start_date: ten_days_after, end_date: twenty_days_after) }

  before{
    future_license
    active_license
    expired_license
    another_future_license
  }

  describe "#lifetime_active" do 
    it 'returns the future licenses' do 
      expect(License.lifetime_active.map(&:id)).to be == [active_license.id]
    end
  end

  describe "#lifetime_inactive" do 
    it 'returns the future licenses' do 
      expect(License.lifetime_inactive.map(&:id)).to be == [expired_license.id, future_license.id, another_future_license.id]
    end
  end

  describe "#lifetime_expired" do 
    it 'returns the future licenses' do 
      expect(License.lifetime_expired.map(&:id)).to be == [expired_license.id]
    end
  end

  describe "#lifetime_future" do 
    it 'returns the future licenses' do 
      expect(License.lifetime_future.map(&:id)).to be == [future_license.id, another_future_license.id]
    end
  end

  describe "#lifetime_ordered" do 
    it 'orders the licences by the start date' do 
      expect(License.all.lifetime_ordered.first.start_date).to be == ten_days_ago
      expect(License.all.lifetime_ordered.last.start_date).to be == ten_days_after
    end
  end

  describe "#lifetime_start_at" do 
    it "returns the lifetime start date" do
      expect(active_license.lifetime_start_at).to eql(five_days_ago)
    end
  end

  describe "#lifetime_end_at" do 
    it "returns the lifetime start date" do
      expect(active_license.lifetime_end_at).to eql(five_days_after)
    end
  end

  describe "#lifetime_active?" do 
    it "returns true for active license" do
      expect(active_license.lifetime_active?).to eql(true)
    end

    it "returns false for inactive/expired license" do
      expect(expired_license.lifetime_active?).to eql(false)
      expect(future_license.lifetime_active?).to eql(false)
    end
  end

  describe "#lifetime_inactive?" do 
    it "returns true for inactive/expired license" do
      expect(expired_license.lifetime_inactive?).to eql(true)
      expect(future_license.lifetime_inactive?).to eql(true)
    end

    it "returns false for active license" do
      expect(active_license.lifetime_inactive?).to eql(false)
    end
  end

  describe "#lifetime_expired?" do 
    it "returns false for active license" do
      expect(active_license.lifetime_expired?).to eql(false)
    end

    it "returns false for future license" do
      expect(future_license.lifetime_expired?).to eql(false)
    end

    it "returns true for expired license" do
      expect(expired_license.lifetime_expired?).to eql(true)
    end
  end

  describe "#lifetime_future?" do 
    it "returns false for active license" do
      expect(active_license.lifetime_future?).to eql(false)
    end

    it "returns true for future license" do
      expect(future_license.lifetime_future?).to eql(true)
    end

    it "returns false for expired license" do
      expect(expired_license.lifetime_future?).to eql(false)
    end
  end

end