require 'spec_helper'

describe 'misp::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Config').that_requires('Class[Misp::Install]') }

      context "With default values" do

        it { is_expected.to contain_file('/var/www/MISP//app/Plugin/CakeResque/Config/config.php')
          .with_ensure('file')
          .with_owner('root')
          .with_group('apache')
          .with_source(%r{/var/www/MISP/})
          .that_subscribes_to('Exec[CakeResque install]') }

        it { is_expected.to contain_exec('Directory permissions')
          .with_command(%r{(root).*(apache).*(/var/www/MISP/)})
          .with_refreshonly('true')
          .that_requires('File[/var/www/MISP//app/Plugin/CakeResque/Config/config.php]')
          .that_subscribes_to('Exec[CakeResque install]') }

        it { is_expected.to contain_file('/var/www/MISP//app/files')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache')
          .that_subscribes_to('Exec[Directory permissions]')
          .that_notifies(['File[/var/www/MISP//app/files/terms]','File[/var/www/MISP//app/files/scripts/tmp]']) }

        it { is_expected.to contain_file('/var/www/MISP//app/files/scripts/tmp')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache') }

        it { is_expected.to contain_file('/var/www/MISP//app/files/terms')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache') }

        it { is_expected.to contain_file('/var/www/MISP//app/Plugin/CakeResque/tmp')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache')
          .that_subscribes_to('Exec[Directory permissions]') }

        it { is_expected.to contain_file('/var/www/MISP//app/tmp')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache')
          .that_subscribes_to('Exec[Directory permissions]')
          .that_notifies('File[/var/www/MISP//app/tmp/logs/]') }

        it { is_expected.to contain_file('/var/www/MISP//app/webroot/img/orgs')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache')
          .that_subscribes_to('Exec[Directory permissions]')
          .that_notifies('File[/var/www/MISP//app/tmp/logs/]') }

        it { is_expected.to contain_file('/var/www/MISP//app/webroot/img/custom')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache')
          .that_subscribes_to('Exec[Directory permissions]')
          .that_notifies('File[/var/www/MISP//app/tmp/logs/]') }

        it { is_expected.to contain_file('/var/www/MISP//app/tmp/logs/')
          .with_ensure('directory')
          .with_owner('apache')
          .with_group('apache') }

        it { is_expected.to contain_file('/var/www/MISP//app/Config//bootstrap.php')
          .with_ensure('file')
          .with_owner('root')
          .with_group('apache') 
          .that_subscribes_to('Exec[Directory permissions]') }

        it { is_expected.to contain_file('/var/www/MISP//app/Config//core.php')
          .with_ensure('file')
          .with_owner('root')
          .with_group('apache') 
          .that_subscribes_to('Exec[Directory permissions]')  }

        it { is_expected.to contain_file('/var/www/MISP//app/Config//config.php')
          .with_ensure('file')
          .with_owner('apache')
          .with_group('apache') 
          .that_subscribes_to('Exec[Directory permissions]')  }

        it { is_expected.to contain_file('/var/www/MISP//app/Config//database.php')
          .with_ensure('file')
          .with_owner('root')
          .with_group('apache') 
          .that_subscribes_to('Exec[Directory permissions]') }

        it { is_expected.to contain_exec('setsebool redis')
          .that_subscribes_to('File[/etc/opt/rh/rh-php56/php.d/99-redis.ini]') }

        it { is_expected.to contain_file('/var/www/MISP//app/Console/worker/start.sh')
          .with_owner('root')
          .with_group('apache') }
      end
      context "With webserver defined" do
      	let(:pre_condition) { 'service{"httpd":}' }
      	it { is_expected.to contain_exec('setsebool redis').that_notifies('Service[httpd]') }
      end
    end
  end
end
