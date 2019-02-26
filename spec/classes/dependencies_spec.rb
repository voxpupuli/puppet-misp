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
      it { is_expected.to contain_package('mariadb') }
      it { is_expected.to contain_package('python-lxml') }
      it { is_expected.to contain_package('python-dateutil') }
      it { is_expected.to contain_package('python-six') }
      it { is_expected.to contain_package('libxslt-devel') }
      it { is_expected.to contain_package('zlib-devel') }
      it { is_expected.to contain_package('rh-php56') }
      it { is_expected.to contain_package('rh-php56-php-fpm') }
      it { is_expected.to contain_package('rh-php56-php-devel') }
      it { is_expected.to contain_package('rh-php56-php-mysqlnd') }
      it { is_expected.to contain_package('rh-php56-php-mbstring') }
      it { is_expected.to contain_package('php-pear') }
      it { is_expected.to contain_package('rh-php56-php-xml') }
      it { is_expected.to contain_package('rh-php56-php-bcmath') }
      it { is_expected.to contain_package('php-mbstring') }
      it { is_expected.to contain_package('haveged') }
      it { is_expected.to contain_package('sclo-php56-php-pecl-redis') }
      it { is_expected.to contain_package('php-pear-crypt-gpg') }
      it { is_expected.to contain_package('python-magic') }
      it { is_expected.to contain_package('ssdeep') }
      it { is_expected.to contain_package('ssdeep-libs') }
      it { is_expected.to contain_package('ssdeep-devel') }
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
