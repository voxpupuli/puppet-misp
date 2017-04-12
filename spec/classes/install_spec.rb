require 'spec_helper'

describe 'misp::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do

        facts
      end
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Install').that_requires('Class[Misp::Dependencies]') }
      
      context "With default values" do

        it {
          is_expected.to contain_vcsrepo('/var/www/MISP/').
          with_ensure('present').
          with_revision(%r{v2.4.[0-9]*})
        }

        it {
          is_expected.to contain_exec('git ignore permissions').
          with_cwd(%r{/var/www/MISP/}).
          that_subscribes_to('Vcsrepo[/var/www/MISP/]').
          that_notifies(['Vcsrepo[/var/www/MISP//app/files/scripts/python-cybox]', 'Vcsrepo[/var/www/MISP//app/files/scripts/python-stix]'])
        }

        it {
          is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/python-cybox').
          with_ensure('present').
          with_source(%r{git://github.com/CybOXProject/python-cybox.git}).
          with_revision(%r{v2.1.0.12})
        } 

        it {
          is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/python-stix').
          with_ensure('present').
          with_source(%r{git://github.com/STIXProject/python-stix.git}).
          with_revision(%r{v1.1.1.4})
        } 

        it {
          is_expected.to contain_exec('python-cybox config').
          with_cwd(%r{/var/www/MISP/}).
          that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/python-cybox]')
        }

        it {
          is_expected.to contain_exec('python-stix config').
          with_cwd(%r{/var/www/MISP/}).
          that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/python-stix]')
        }

        it {
          is_expected.to contain_exec('CakeResque curl').
          with_cwd(%r{/var/www/MISP/}).
          with_environment(%r{/var/www/MISP/}).
          that_subscribes_to('Exec[git ignore permissions]').
          that_notifies('Exec[CakeResque kamisama]')
        }

        it {
          is_expected.to contain_exec('CakeResque kamisama').
          with_cwd(%r{/var/www/MISP/}).
          with_environment(%r{/var/www/MISP/}).
          with_refreshonly('true').
          that_notifies('Exec[CakeResque config]')
        }

        it {
          is_expected.to contain_exec('CakeResque config').
          with_cwd(%r{/var/www/MISP/}).
          with_environment(%r{/var/www/MISP/}).
          with_refreshonly('true').
          that_notifies('Exec[CakeResque install]')
        }

        it {
          is_expected.to contain_exec('CakeResque install').
          with_cwd(%r{/var/www/MISP/}).
          with_environment(%r{/var/www/MISP/}).
          with_refreshonly('true').
          that_notifies(['File[/etc/opt/rh/rh-php56/php-fpm.d/redis.ini]', 'File[/etc/opt/rh/rh-php56/php-fpm.d/timezone.ini]'])
        }

        it {
          is_expected.to contain_file('/etc/opt/rh/rh-php56/php-fpm.d/redis.ini').
          with_ensure('file').
          with_content('extension=redis.so')
        }
        it {
          is_expected.to contain_file('/etc/opt/rh/rh-php56/php.d/99-redis.ini').
          with_ensure('link').
          that_subscribes_to('File[/etc/opt/rh/rh-php56/php-fpm.d/redis.ini]')
        }
        it {
          is_expected.to contain_file('/etc/opt/rh/rh-php56/php-fpm.d/timezone.ini').
          with_ensure('file')
        }

        it {
          is_expected.to contain_file('/etc/opt/rh/rh-php56/php.d/99-timezone.ini').
          with_ensure('link').
          that_subscribes_to('File[/etc/opt/rh/rh-php56/php-fpm.d/timezone.ini]')
        }

        it {
          is_expected.to contain_file('/var/www/MISP//app/Console/worker/status.sh').
          with_owner('root').
          with_group('apache').
          with_ensure('file').
          that_subscribes_to('Vcsrepo[/var/www/MISP/]')
        }
      end
    end
  end
end
