require 'spec_helper'

describe Review do
  context 'associations' do
    it { should belong_to(:video) }
    it { should belong_to(:author).
                  class_name('User').
                  with_foreign_key('user_id') }
  end

  context 'validations' do
    it { should validate_presence_of(:video) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:rating) }

    it { should validate_numericality_of(:rating).
                is_less_than_or_equal_to(5).
                is_greater_than_or_equal_to(1) }
  end
end
