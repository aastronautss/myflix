require 'spec_helper'

describe Video do
  context 'associations' do
    it { should belong_to(:category) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
