require 'spec_helper'

describe User do
  context 'associations' do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:queue_members).dependent(:destroy).order('list_order asc') }
  end

  context 'validations' do
    it { should have_secure_password }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:password) }

    it { should validate_uniqueness_of(:email) }

    it do
      should validate_length_of(:password).
        is_at_least(5).is_at_most(30)
    end
    it do
      should validate_length_of(:full_name).
        is_at_least(2)
    end
  end
end
