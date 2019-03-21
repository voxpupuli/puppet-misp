require 'spec_helper'

describe 'misp::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Install').that_requires('Class[Misp::Dependencies]') }
      context 'With default values' do
        it do
          is_expected.to contain_vcsrepo('/var/www/MISP/').
            with_ensure('present').
            with_revision(%r{v2.4.[0-9]*})
        end

        it do
          is_expected.to contain_file('/var/www/MISP//.git/ORIG_HEAD').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            with_replace(false).
            that_requires('Vcsrepo[/var/www/MISP/]')
        end

        it do
          is_expected.to contain_exec('git ignore permissions').
            with_cwd(%r{/var/www/MISP/}).
            that_subscribes_to('Vcsrepo[/var/www/MISP/]').
            that_notifies(['Vcsrepo[/var/www/MISP//app/files/scripts/python-cybox]', 'Vcsrepo[/var/www/MISP//app/files/scripts/python-stix]'])
        end

        it do
          is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/python-stix').
            with_ensure('present').
            with_source('https://github.com/STIXProject/python-stix.git').
            with_revision('v1.2.0.6')
        end

        it do
          is_expected.to contain_exec('Install python-stix').
            with_cwd('/var/www/MISP//app/files/scripts/python-stix/').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022').
            that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/python-stix]')
        end

        it do
          is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/python-cybox').
            with_ensure('present').
            with_source('https://github.com/CybOXProject/python-cybox.git').
            with_revision('85f975a89119e63bc2d7a67513b0f18e358c468f')
        end

        it do
          is_expected.to contain_exec('Uninstall old cybox').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install python-cybox').
            with_cwd('/var/www/MISP//app/files/scripts/python-cybox/').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022').
            that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/python-cybox]')
        end

        it do
          is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/mixbox').
            with_ensure('present').
            with_source('https://github.com/CybOXProject/mixbox.git').
            with_revision('v1.0.3')
        end

        it do
          is_expected.to contain_exec('Install mixbox').
            with_cwd('/var/www/MISP//app/files/scripts/mixbox/').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022').
            that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/mixbox]')
        end

        it do
          is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/python-maec').
            with_ensure('present').
            with_source('https://github.com/MAECProject/python-maec.git').
            with_revision('v4.1.0.14')
        end

        it do
          is_expected.to contain_exec('Install python-maec').
            with_cwd('/var/www/MISP//app/files/scripts/python-maec/').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022').
            that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/python-maec]')
        end

        it do
          is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/pydeep').
            with_ensure('present').
            with_source('https://github.com/kbandla/pydeep.git').
            with_revision('60b0a00ba7f30cfa21ff92d871799685bc612cad')
        end

        it do
          is_expected.to contain_exec('Install pydeep').
            with_cwd('/var/www/MISP//app/files/scripts/pydeep/').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022').
            that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/pydeep]')
        end

        it do
          is_expected.to contain_exec('Pear install Console_CommandLine').
            with_cwd('/var/www/MISP//')
        end

        it do
          is_expected.to contain_exec('Pear install Crypt_GPG').
            with_cwd('/var/www/MISP//')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//venv').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache').
            that_requires('Vcsrepo[/var/www/MISP/]')
        end

        it do
          is_expected.to contain_exec('Create MISP virtualenv').
            with_creates('/var/www/MISP//venv/bin/activate').
            with_user('apache').
            that_requires('File[/var/www/MISP//venv]')
        end

        it do
          is_expected.to contain_exec('Install python-dateutil').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install python-magic').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install enum34').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install lxml').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install six').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install zmq').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install stix2 v1.1.1').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022')
        end

        it do
          is_expected.to contain_exec('Install pymisp').
            with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
            with_user('apache').
            with_umask('0022').
            that_requires('Exec[Create MISP virtualenv]')
        end

        it do
          is_expected.to contain_file('/usr/share/httpd/.composer').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/Plugin/CakeResque').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/cache').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache').
            with_seltype('httpd_sys_rw_content_t')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/vendor').
            with_ensure('directory').
            with_owner('apache').
            with_group('apache')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/Vendor').
            with_ensure('link').
            with_target('/var/www/MISP//app/vendor')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/composer.json').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            with_replace(false)
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/composer.lock').
            with_ensure('file').
            with_owner('apache').
            with_group('apache').
            with_replace(false)
        end

        it do
          is_expected.to contain_exec('CakeResque require').
            with_cwd('/var/www/MISP//app/').
            with_environment(['COMPOSER_HOME=/var/www/MISP//app/']).
            with_user('apache').
            that_notifies('Exec[CakeResque install]')
        end

        it do
          is_expected.to contain_exec('CakeResque config').
            with_cwd('/var/www/MISP//app/').
            with_environment(['COMPOSER_HOME=/var/www/MISP//app/']).
            with_refreshonly('true').
            that_notifies('Exec[CakeResque install]')
        end

        it do
          is_expected.to contain_exec('CakeResque install').
            with_cwd('/var/www/MISP//app/').
            with_environment(['COMPOSER_HOME=/var/www/MISP//app/']).
            with_refreshonly('true').
            that_notifies(['File[/etc/opt/rh/rh-php72/php-fpm.d/timezone.ini]'])
        end

        it do
          is_expected.to contain_file('/etc/opt/rh/rh-php72/php-fpm.d/timezone.ini').
            with_ensure('file')
        end

        it do
          is_expected.to contain_file('/etc/opt/rh/rh-php72/php.d/99-timezone.ini').
            with_ensure('link').
            that_subscribes_to('File[/etc/opt/rh/rh-php72/php-fpm.d/timezone.ini]')
        end

        it do
          is_expected.to contain_file('/etc/systemd/system/misp-workers.service').
            with_ensure('file').
            that_notifies('Service[misp-workers]')
        end

        it do
          is_expected.to contain_file('/var/www/MISP//app/Console/worker/start.sh').
            with_owner('root').
            with_group('apache').
            with_mode('+x')
        end
      end
    end

    context "on #{os} without virtualenv" do
      let(:facts) do
        facts
      end

      let(:pre_condition) do
        'class { "misp": use_venv => false }'
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.not_to contain_exec('Create MISP virtualenv') }

      it do
        is_expected.not_to contain_exec('Install pymisp').
          that_requires('Exec[Create MISP virtualenv]')
      end
    end

    context "on #{os} when building LIEF" do
      let(:facts) do
        facts
      end

      let(:pre_condition) do
        'class { "misp": build_lief => true }'
      end

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_vcsrepo('/var/www/MISP//app/files/scripts/lief').
          with_ensure('present').
          with_source('https://github.com/lief-project/LIEF.git').
          with_revision('0.9.0')
      end

      it do
        is_expected.to contain_exec('Ensure LIEF build dir').
          with_cwd('/').
          with_user('apache').
          with_creates('/var/www/MISP//app/files/scripts/lief/build').
          that_requires('Vcsrepo[/var/www/MISP//app/files/scripts/lief]')
      end

      it do
        is_expected.to contain_exec('Set up LIEF build').
          with_cwd('/var/www/MISP//app/files/scripts/lief/build').
          with_user('apache').
          with_creates('/var/www/MISP//app/files/scripts/lief/build/CMakeCache.txt').
          that_requires('Exec[Ensure LIEF build dir]').
          that_subscribes_to('Vcsrepo[/var/www/MISP//app/files/scripts/lief]')
      end

      it do
        is_expected.to contain_exec('Compile LIEF').
          with_cwd('/var/www/MISP//app/files/scripts/lief/build').
          with_user('apache').
          with_creates('/var/www/MISP//app/files/scripts/lief/build/api/python/_pylief.so').
          that_subscribes_to('Exec[Set up LIEF build]')
      end

      it do
        is_expected.to contain_exec('Uninstall faulty LIEF').
          with_cwd('/var/www/MISP//app/files/scripts/lief/build').
          with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
          with_user('apache').
          that_notifies('Exec[Install LIEF]')
      end

      it do
        is_expected.to contain_exec('Install LIEF').
          with_cwd('/var/www/MISP//app/files/scripts/lief/build/api/python').
          with_path(%w[/var/www/MISP//venv/bin /usr/bin /bin]).
          with_user('apache').
          that_subscribes_to('Exec[Compile LIEF]')
      end
    end
  end
end
