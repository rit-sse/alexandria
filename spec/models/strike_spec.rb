require 'spec_helper'

describe Strike do
  let(:reason) { create(:reason) }
  let(:patron) { create(:patron) }
  let(:other_reason) { Reason.create(message: 'Other') }
  let(:distributor) { create(:distributor) }

  before(:each) do
    @strike = Strike.new(other_info: 'Test info')
    @strike.patron = patron
    @strike.distributor = distributor
    @strike.reason = reason
    @strike.save
  end

  it 'can be created' do
    expect(@strike).to_not be_nil
  end

  describe 'missing fields' do
    it 'can not be created without a patron' do
      expect do
        strike = Strike.new(other_info: 'Test info')
        strike.distributor = distributor
        strike.reason = reason
        strike.save
      end.to_not change { Strike.all.count }
    end

    it 'can not be created without a distributor' do
      expect do
        strike = Strike.new(other_info: 'Test info')
        strike.patron = patron
        strike.reason = reason
        strike.save
      end.to_not change { Strike.all.count }
    end

    it 'can not be created without a reason' do
      expect do
        strike = Strike.new(other_info: 'Test info')
        strike.patron = patron
        strike.distributor = distributor
        strike.save
      end.to_not change { Strike.all.count }
    end
  end

  describe 'validations' do
    it 'can not be created with a patron distributor' do
      expect do
        strike = Strike.new(other_info: 'Test info')
        strike.patron = patron
        strike.distributor = patron
        strike.reason = reason
        strike.save
      end.to_not change { Strike.all.count }
    end

    it 'can not be created with no description for other' do
      expect do
        strike = Strike.new
        strike.patron = patron
        strike.distributor = distributor
        strike.reason = other_reason
        strike.save
      end.to_not change { Strike.all.count }
    end
  end

  it 'message is right' do
    expect(@strike.message).to eq('Overdue book: Test info')
    @strike.other_info = ''
    expect(@strike.message).to eq('Overdue book')
  end
end
