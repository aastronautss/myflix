require 'spec_helper'

describe UserSignup do
  describe '#sign_up' do
    context 'with valid personal info and valid card' do
      before do
        user = Fabricate.build :user

        response = double :charge, successful?: true
        expect(StripeWrapper::Charge).to receive(:create).and_return(response)

        UserSignup.new(user).sign_up('abcd', nil)
      end

      it 'creates the user' do
        expect(User.count).to eq(1)
      end

      context 'sending email' do
        after do
          ActionMailer::Base.deliveries.clear
        end

        it 'sends out the email' do
          deliveries = ActionMailer::Base.deliveries
          expect(deliveries).to_not be_empty
        end

        it 'sends to the right recipient' do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to include(User.first.email)
        end

        it 'has the right content' do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(User.first.full_name)
        end
      end
    end

    context 'with valid personal info and declined card' do
      before do
        user = Fabricate.build :user

        response = double :charge, successful?: false, message: 'Declined'
        expect(StripeWrapper::Charge).to receive(:create).and_return(response)

        UserSignup.new(user).sign_up('abcd', nil)
      end

      it 'does not create a user record' do
        expect(User.count).to eq(0)
      end
    end

    context 'with invalid personal info' do
      let(:user) { User.new(Fabricate.attributes_for :user, email: '') }
      before do
        response = double :charge, successful?: true
      end

      it 'does not create a user' do
        UserSignup.new(user).sign_up('abcd', nil)
        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        expect(StripeWrapper::Charge).to_not receive(:create)
        UserSignup.new(user).sign_up('abcd', nil)
      end
    end

    context 'with invite token given' do
      let(:inviter) { Fabricate :user }
      let(:invitee) { Fabricate.build :user }
      before(:each) do
        response = double :charge, successful?: true
        expect(StripeWrapper::Charge).to receive(:create).and_return(response)

        invite = Fabricate :invite, inviter: inviter
        UserSignup.new(invitee).sign_up('abcd', invite.token)
      end

      it 'sets the inviter as following the invitee' do
        expect(inviter.reload.is_following? invitee).to be(true)
      end

      it 'sets the invitee as following the inviter' do
        expect(invitee.reload.is_following? inviter).to be(true)
      end

      it 'expires the token' do
        expect(Invite.first.reload.token).to be_nil
      end
    end
  end
end
