require 'spec_helper'

describe Invite do
  context 'associations' do
    it do
      should belong_to(:inviter).
        class_name('User').
        with_foreign_key('inviter_id')
    end

    it do
      should belong_to(:invitee).
        class_name('User').
        with_foreign_key('invitee_id')
    end
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
  end
end
