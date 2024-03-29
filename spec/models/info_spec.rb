# == Schema Information
#
# Table name: infos
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  info_type  :string(255)
#

require 'spec_helper'

describe Info do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @info = user.infos.build(content: "www.soundcloud.com/Loremipsum",
                              info_type: "soundcloud")
  end

  subject { @info }

  it { should respond_to(:content) }
  it { should respond_to(:info_type) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Info.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { @info.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @info.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @info.content = "a" * 81 }
    it { should_not be_valid }
  end

end
