require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'account' do

  let(:title) { 'account' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test minimal installation' do
    it { should include_class('account::local') }
  end

  describe 'Test backend ldap' do
    let(:params) { {:backend => "ldap"} }
    it { should include_class('account::ldap') }
  end
end
