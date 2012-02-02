#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class InvitationsController < ApplicationController

  def new
    @invite_code = current_user.invitation_code
    @sent_invitations = current_user.invitations_from_me.includes(:recipient)
    respond_to do |format|
      format.html do
        render :layout => false
      end
    end
  end

  def edit
    user = User.find_by_invitation_token(params[:invitation_token])
    invitation_code = user.ugly_accept_invitation_code
    redirect_to invite_code_path(invitation_code)
  end

  def check_if_invites_open
    unless AppConfig[:open_invitations]
      flash[:error] = I18n.t 'invitations.create.no_more'
      redirect_to :back
      return
    end
  end

  def create
    emails = params[:email].to_s.gsub(/\s/, '').split(/, */)
    language = params[:language]
    invites = Invitation.batch_invite(emails, :message => message, :sender => current_user, :aspect => aspect, :service => 'email', :language => language)
    flash[:notice] = 
    puts params.inspect
    redirect_to root_path
  end
end