require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'account' do

  let(:title) { 'account' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test minimal installation' do
    it { should contain_class('account::local') }
    it { should contain_file('home.dir').with_ensure('directory') }
  end

  describe 'Test backend ldap' do
    let(:params) { {:backend => "ldap"} }
    it { should contain_class('account::ldap') }
    it { should contain_file('home.dir').with_ensure('directory') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_file('home.dir').with_noop('true') }
  end

end
