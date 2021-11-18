require 'rails_helper'

RSpec.describe Organization, type: :model do
  context 'when running validations' do

    let(:owner_user) { create(:user, role: :owner) }
    let(:not_owner_user) { create(:user) }
    let(:not_unique_org) { create(:organization, user: owner_user) }

    subject { build(:organization, user: owner_user) }

    it 'ensures name presence' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'ensures name uniqueness' do
      subject.name = not_unique_org.name
      expect(subject).to_not be_valid
    end

    it 'ensures owner user_id presence' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'ensures user with given user_id has owner role' do
      subject.user_id = not_owner_user.id
      expect(subject).to_not be_valid
    end

    it 'ensures description presence' do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it 'should be valid if all attributes are valid' do
      expect(subject).to be_valid
    end

  end
end
