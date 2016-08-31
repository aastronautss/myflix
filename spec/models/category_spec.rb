require 'spec_helper'

describe Category do
  context 'associations' do
    it { should have_many(:videos) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
