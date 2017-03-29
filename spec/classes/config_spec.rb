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
        it { is_expected.to contain_file('/var/www/MISP//app/Plugin/CakeResque/Config/config.php').with(
  		    'ensure'  => 'file',
  		  ).that_subscribes_to('Exec[CakeResque install]') }
        it { is_expected.to contain_exec('Directory permissions').with(
          'refreshonly' => 'true',
          ).that_requires('File[/var/www/MISP//app/Plugin/CakeResque/Config/config.php]')
        .that_subscribes_to('Exec[CakeResque install]') }
        it { is_expected.to contain_file('/var/www/MISP//app/files').with(
  		    'ensure'  => 'directory',
  		  ).that_subscribes_to('Exec[Directory permissions]').that_notifies(['File[/var/www/MISP//app/files/terms]','File[/var/www/MISP//app/files/scripts/tmp]']) }
        it { is_expected.to contain_file('/var/www/MISP//app/files/scripts/tmp').with(
  		    'ensure'  => 'directory',
  		  ) }
        it { is_expected.to contain_file('/var/www/MISP//app/files/terms').with(
  		    'ensure'  => 'directory',
  		  ) }
        it { is_expected.to contain_file('/var/www/MISP//app/Plugin/CakeResque/tmp').with(
  		    'ensure'  => 'directory',
  		  ).that_subscribes_to('Exec[Directory permissions]') }
        it { is_expected.to contain_file('/var/www/MISP//app/tmp').with(
  		    'ensure'  => 'directory',
  		  ).that_subscribes_to('Exec[Directory permissions]').that_notifies('File[/var/www/MISP//app/tmp/logs/]') }
        it { is_expected.to contain_file('/var/www/MISP//app/webroot/img/orgs').with(
  		    'ensure'  => 'directory',
  		  ).that_subscribes_to('Exec[Directory permissions]').that_notifies('File[/var/www/MISP//app/tmp/logs/]') }
        it { is_expected.to contain_file('/var/www/MISP//app/webroot/img/custom').with(
  		    'ensure'  => 'directory',
  		  ).that_subscribes_to('Exec[Directory permissions]').that_notifies('File[/var/www/MISP//app/tmp/logs/]') }
        it { is_expected.to contain_file('/var/www/MISP//app/tmp/logs/') }
        it { is_expected.to contain_file('/var/www/MISP//app/Config//bootstrap.php').that_subscribes_to('Exec[Directory permissions]') }
        it { is_expected.to contain_file('/var/www/MISP//app/Config//core.php').that_subscribes_to('Exec[Directory permissions]')  }
        it { is_expected.to contain_file('/var/www/MISP//app/Config//config.php').that_subscribes_to('Exec[Directory permissions]')  }
        it { is_expected.to contain_file('/var/www/MISP//app/Config//database.php').that_subscribes_to('Exec[Directory permissions]') }
        it { is_expected.to contain_exec('setsebool redis').that_subscribes_to('File[/etc/opt/rh/rh-php56/php.d/99-redis.ini]') }
        it { is_expected.to contain_file('/var/www/MISP//app/Console/worker/start.sh') }
      end
      context "With webserver defined" do
      	let(:pre_condition) { 'service{"httpd":}' }
      	it { is_expected.to contain_exec('setsebool redis').that_notifies('Service[httpd]') }
      end
    end
  end
end
