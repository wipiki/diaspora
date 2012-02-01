# Copyright (c) 2010-2011, Diaspora Inc. This file is
# licensed under the Affero General Public License version 3 or later. See
# the COPYRIGHT file.

class Stream::Participation < Stream::Base
  def link(opts={})
    Rails.application.routes.url_helpers.participation_stream_path(opts)
  end

  def title
    I18n.translate("streams.participation_stream.title")
  end

  # @return [ActiveRecord::Association<Post>] AR association of posts
  def posts
    @posts ||= Diaspora::EvilQuery::ParticipationStream.new(self.user, 'updated_at', max_time).make_relation!
  end

  def contacts_title
    I18n.translate('streams.participation_stream.contacts_title')
  end
end
