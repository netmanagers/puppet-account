require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'account::user' do

  let(:title) { 'account::user' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } } 

  describe 'All default values, just title provided' do
    it do
      should contain_group( title ).with({
        'ensure' => 'present',
        'name'   => title,
        'system' => false,
        'gid'    => nil,
        'before' => "User[#{title}]",
      })
    end

    it do
      should contain_user( title ).with({
        'ensure'     => 'present',
        'name'       => title,
        'uid'        => nil,
        'password'   => nil,
        'shell'      => '/bin/bash',
        'gid'        => title,
        'groups'     => [],
        'home'       => "/home/#{title}",
        'managehome' => true,
        'system'     => false,
        'before'     => "File[#{title}_home]",
      })
    end

    it do
      should contain_file( "#{title}_home" ).with({
        'ensure'  => 'directory',
        'path'    => "/home/#{title}",
        'owner'   => title,
        'group'   => title,
        'mode'    => '0700',
        'before'  => "File[#{title}_sshdir]",
      })
    end

    it do
      should contain_file( "#{title}_sshdir" ).with({
        'ensure'  => 'directory',
        'path'    => "/home/#{title}/.ssh",
        'owner'   => title,
        'group'   => title,
        'mode'    => '0700',
      })
    end
  end

  describe 'account with custom values' do
    let( :title ) { 'admin' }
    let( :params ) {{
      :username    => 'sysadmin',
      :shell       => '/bin/zsh',
      :manage_home => false,
      :home_dir    => '/opt/admin',
      :system      => true,
      :uid         => '777',
      :groups      => [ 'sudo', 'users' ],
    }}

    it do
      should contain_group('sysadmin').with({
        'ensure' => 'present',
        'name'   => params[:username],
        'system' => true,
        'gid'    => params[:uid],
      })
    end

    it do
      should contain_user('sysadmin').with({
        'name'        => params[:username],
        'uid'         => params[:uid],
        'shell'       => params[:shell],
        'gid'         => params[:username],
        'groups'      => params[:groups],
        'home'        => params[:home_dir],
        'manage_home' => params[:manage_home] == false ? nil : true,
        'system'      => params[:system],
      })
    end

    it do
      should contain_file( 'sysadmin_home' ).with({
        'path'  => params[:home_dir],
        'owner' => params[:username],
        'group' => params[:username],
      })
    end

    it do 
      should contain_file( 'sysadmin_sshdir' ).with({
        'path' => "#{params[:home_dir]}/.ssh",
        'owner' => params[:username],
        'group' => params[:username],
      })
    end
  end

  describe 'account with no dedicated group nor group set' do
    let( :title ) { 'user' }
    let( :params) {{ :create_group => false}}

    it do
      should_not contain_group( title )
    end

    it do
      should contain_user( title ).with({ 'gid' => '100' })
    end

    it do
      should contain_file( 'user_home' ).with({ 'group' => '100' })
    end

    it do
      should contain_file( 'user_sshdir' ).with({ 'group' => '100' })
    end
  end

  describe 'account with no dedicated group' do
    let( :title ) { 'otheruser' }
    let( :params ) {{ :create_group => false, :gid => 'staff' }}

    it do
      should_not contain_group( title )
    end

    it do
      should contain_user( title ).with({ 'gid' => params[:gid] })
    end

    it do
      should contain_file( 'otheruser_home' ).with({ 'group' => params[:gid] })
    end

    it do
      should contain_file( 'otheruser_sshdir' ).with({ 'group' => params[:gid] })
    end
  end
end
