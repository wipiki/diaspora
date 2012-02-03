#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe InvitationsController do
  include Devise::TestHelpers

  before do
    AppConfig[:open_invitations] = true
    @user   = alice
    @invite = {:email_inviter => {:message=>"test", :emails=>"abc@example.com"}}

    request.env["devise.mapping"] = Devise.mappings[:user]
    Webfinger.stub_chain(:new, :fetch).and_return(Factory(:person))
  end

  describe "#create" do
    before do
      sign_in :user, @user
      @controller.stub!(:current_user).and_return(@user)
      request.env["HTTP_REFERER"]= 'http://test.host/cats/foo'
    end

    it 'saves an invitation'  do
      expect {
        post :create,  @invite
      }.should change(Invitation, :count).by(1)
    end

    it 'handles a comma-separated list of emails' do
      expect{
        post :create, @invite.merge(
        :emails => "foofoofoofoo@example.com, mbs@gmail.com")
      }.should change(Invitation, :count).by(2)
    end

    it 'handles a comma-separated list of emails with whitespace' do
      expect {
        post :create, @invite.merge(
          :email => "foofoofoofoo@example.com   ,        mbs@gmail.com")
          }.should change(Invitation, :count).by(2)
    end

    it "allows invitations without if invitations are open" do
      open_bit = AppConfig[:open_invitations]
      AppConfig[:open_invitations] = true

      expect{
        post :create, :@invite
      }.to change(Invitation, :count).by(1)
      AppConfig[:open_invitations] = open_bit
    end

    it 'returns to the previous page on success' do
      post :create, :@invite
      response.should redirect_to("http://test.host/cats/foo")
    end

    it 'strips out your own email' do
      lambda {
        post :create, @invite.merge(:email => @user.email)
      }.should_not change(Invitation, :count)

      expect{
        post :create, @invite.merge(:email => "hello@example.org, #{@user.email}")
      }.should change(Invitation, :count).by(1)
    end
  end


  describe '#new' do
    it 'renders' do
      sign_in :user, @user
      get :new
    end
  end
end
