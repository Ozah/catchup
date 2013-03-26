# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  contact_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Relationship do
  let(:user) { FactoryGirl.create(:user) }
  let(:contact) { FactoryGirl.create(:user) }
  let(:relationship) { user.relationships.build(contact_id: contact.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    it { should respond_to(:user) }
    it { should respond_to(:contact) }
    its(:user) { should == user }
    its(:contact) { should == contact }
  end

  describe "when followed id is not present" do
    before { relationship.contact_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.user_id = nil }
    it { should_not be_valid }
  end
end
