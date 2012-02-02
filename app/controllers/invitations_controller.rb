#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class InvitationsController < ApplicationController

  def new
    @invite_code = current_user.invitation_code InvitationCode.find_or_create_by_user_id(current_user.id)
    @sent_invitations = current_user.invitations_from_me.includes(:recipient)
    respond_to do |format|
      format.html do
        render :layout => false
      end
    end
  end


  def check_if_invites_open
    unless AppConfig[:open_invitations]
      flash[:error] = I18n.t 'invitations.create.no_more'
      redirect_to :back
      return
    end
  end
end