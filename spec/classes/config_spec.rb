# frozen_string_literal: true

require 'spec_helper'

describe 'misp::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Config').that_requires('Class[Misp::Install]') }

      context 'With default values' do
        it do
          is_expected.to contain_file('/var/www/MISP//app/Plugin/CakeResque/Config/config.php').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            with_source(%r{/var/www/MISP/}).
            that_subscribes_to('Exec[CakeResque install]')
        end

        it do
          is_expected.to contain_exec('Directory permissions').
            with_command(%r{(root).*(apache).*(/var/www/MISP/)}).
            with_refreshonly('true').
            that_requires('File[/var/www/MISP//app/Plugin/CakeResque/Config/config.php]').
            that_subscribes_to('Exec[CakeResque install]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/files').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]').
            that_notifies(['File[/var/www/MISP//app/files/terms]', 'File[/var/www/MISP//app/files/scripts/tmp]'])
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/files/scripts/tmp').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/files/terms').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/Plugin/CakeResque/tmp').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/tmp').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]').
            that_notifies('File[/var/www/MISP//app/tmp/logs/]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/webroot/img/orgs').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]').
            that_notifies('File[/var/www/MISP//app/tmp/logs/]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/webroot/img/custom').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]').
            that_notifies('File[/var/www/MISP//app/tmp/logs/]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/tmp/logs/').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache')
        end

        it do
          is_expected.to contain_file('/var/www/MISP/app/Config//bootstrap.php').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP/app/Config//core.php').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP/app/Config//config.php').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP/app/Config//database.php').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            that_subscribes_to('Exec[Directory permissions]')
        end

        it do
          is_expected.to contain_selboolean('httpd redis connection')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/Console/worker/start.sh').
            with_owner('root').
            with_group('apache')
        end
      end

      context 'With webserver defined' do
        let(:pre_condition) do
          'service{"httpd":}'
        end
        let(:facts) do
          data = facts
          ((data[:os] ||= {})[:selinux] ||= {})[:enabled] = false
          data
        end

        it do
          is_expected.not_to contain_selboolean('httpd redis connection').
            that_notifies('Service[httpd]')
        end
      end

      context 'With SELinux enabled and webserver defined' do
        let(:facts) do
          data = facts
          ((data[:os] ||= {})[:selinux] ||= {})[:enabled] = true
          data
        end
        let(:pre_condition) do
          'service{"httpd":}'
        end

        it do
          is_expected.to contain_selboolean('httpd redis connection').
            that_notifies('Service[httpd]')
        end
      end
    end
  end
end
