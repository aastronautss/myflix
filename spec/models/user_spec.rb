require 'spec_helper'

describe User do
  context 'validations' do
    it { should have_secure_password }

    it do
      should validate_presence_of(:email)
    end
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:password) }

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
