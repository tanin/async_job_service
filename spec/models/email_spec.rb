require 'rails_helper'

describe Email, type: :model do
  let(:email) { create(:email) }

  it 'creates record' do
    expect(email).to be_persisted
  end

  describe 'validation' do
    it 'validates data presence' do
      expect(build(:email, data: nil)).to_not be_valid
    end

    it 'validates external_id presence' do
      expect(build(:email, external_id: nil)).to_not be_valid
    end

    it 'validates external_id uniqueness' do
      email
      expect(build(:email, external_id: email.external_id)).to_not be_valid
    end
  end
end
