# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  meeting_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Note do
  pending "add some examples to (or delete) #{__FILE__}"
end
