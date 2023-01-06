# frozen_string_literal: true

require 'spec_helper'

describe 'misp::dependencies' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Dependencies') }
      it { is_expected.to contain_package('gcc') }
      it { is_expected.to contain_package('git') }
      it { is_expected.to contain_package('zip') }
      it { is_expected.to contain_package('libxslt-devel') }
      it { is_expected.to contain_package('zlib-devel') }
      it { is_expected.to contain_package('ssdeep') }
      it { is_expected.to contain_package('ssdeep-libs') }
      it { is_expected.to contain_package('ssdeep-devel') }
      it { is_expected.to contain_package('rh-php72') }
      it { is_expected.to contain_package('rh-php72-php-fpm') }
      it { is_expected.to contain_package('rh-php72-php-devel') }
      it { is_expected.to contain_package('rh-php72-php-mysqlnd') }
      it { is_expected.to contain_package('rh-php72-php-mbstring') }
      it { is_expected.to contain_package('rh-php72-php-pear') }
      it { is_expected.to contain_package('rh-php72-php-xml') }
      it { is_expected.to contain_package('rh-php72-php-bcmath') }
      it { is_expected.to contain_package('sclo-php72-php-pecl-redis4') }
      it { is_expected.to contain_package('rh-python36') }
      it { is_expected.to contain_package('rh-python36-python-devel') }
      it { is_expected.to contain_package('rh-python36-python-pip') }
      it { is_expected.to contain_package('rh-python36-python-six') }
    end

    context "on #{os} with PHP7.3" do
      let(:facts) do
        facts
      end

      let(:pre_condition) do
        'class { "misp": php_version => "php73" }'
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('rh-php73') }
      it { is_expected.to contain_package('rh-php73-php-fpm') }
      it { is_expected.to contain_package('rh-php73-php-devel') }
      it { is_expected.to contain_package('rh-php73-php-mysqlnd') }
      it { is_expected.to contain_package('rh-php73-php-mbstring') }
      it { is_expected.to contain_package('rh-php73-php-pear') }
      it { is_expected.to contain_package('rh-php73-php-xml') }
      it { is_expected.to contain_package('rh-php73-php-bcmath') }
      it { is_expected.to contain_package('sclo-php73-php-pecl-redis4') }
      it { is_expected.to contain_file('/etc/opt/rh/rh-php73/php-fpm.d/timezone.ini') }
      it { is_expected.to contain_file('/etc/opt/rh/rh-php73/php-fpm.d/memory_limit.ini') }
      it { is_expected.to contain_file('/etc/opt/rh/rh-php73/php.d/99-timezone.ini') }
      it { is_expected.to contain_service('rh-php73-php-fpm') }
    end

    context "on #{os} when building LIEF" do
      let(:facts) do
        facts
      end

      let(:pre_condition) do
        'class { "misp": build_lief => true }'
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('cmake3') }
      it { is_expected.to contain_package('devtoolset-7') }
    end

    context "on #{os} with `ensure => latest` resources" do
      let(:facts) do
        facts
      end

      let(:pre_condition) do
        'package { "git": ensure => latest }'
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
