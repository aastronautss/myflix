require 'spec_helper'

describe QueueMember do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end

  context 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:video) }
    it { should validate_presence_of(:list_order) }
  end
end
