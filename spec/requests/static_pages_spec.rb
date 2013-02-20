require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Start page" do
    before { visit start_path }

    it { should have_content('CATCHUP') }
    it { should have_link('Sign up') }
    it { should have_link('Sign in') }
    it { should have_link('Sign up as guest') }
  end
end
