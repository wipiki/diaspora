require 'spec_helper'

describe Diaspora::EvilQuery  do

  describe Diaspora::EvilQuery::ParticipationStream do
    it 'works ok' do
      Diaspora::EvilQuery::ParticipationStream.new(Factory(:user), 'updated_at', Time.now)
    end
  end
  
end