require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'account::sshkey' do

  let(:title) { 'account::sshkey' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } } 

  describe 'All default values, just title provided' do
    it do
      raise_error(Puppet::Error, "Invalid value given for ssh-key. Can't be empty.")
    end
  end

  describe 'Add user key' do
    let(:params) do
      {
        :username => 'joe',
        :ssh_key  => 'blablebli',
      }
    end

    it do
      should contain_ssh_authorized_key( title ).with({
        'ensure' => 'present',
        'name'   => "#{title} SSH Key",
        'type'   => 'ssh-rsa',
        'key'    => params[:ssh_key],
      })
    end
  end

  describe 'Add user key with other name' do
    let(:params) do
      {
        :username => 'joe',
        :ssh_key  => 'blablebli',
        :comment  => 'some new key name',
      }
    end

    it do
      should contain_ssh_authorized_key( title ).with({
        'ensure' => 'present',
        'name'   => params[:comment],
        'type'   => 'ssh-rsa',
        'key'    => params[:ssh_key],
      })
    end
  end

  describe 'Remove user key' do
    let(:params) do
      {
        :username     => 'joe',
        :ssh_key      => 'blable',
        :ssh_key_type => 'some-key-type',
        :ensure       => 'absent',
      }
    end

    it do
      should contain_ssh_authorized_key( title ).with({
        'ensure' => 'absent',
        'name'   => "#{title} SSH Key",
        'key'    => params[:ssh_key],
        'type'   => params[:ssh_key_type],
      })
    end
  end
end
