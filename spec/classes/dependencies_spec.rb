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
      it { is_expected.to contain_package('python-devel') }
      it { is_expected.to contain_package('python2-pip') }
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
      it { is_expected.to contain_package('php-mbstring') }
      it { is_expected.to contain_package('haveged') }
      context 'With default values' do
        it { is_expected.to contain_package('redis') }
        it { is_expected.to contain_exec('php56 redis') }
        it { is_expected.to contain_exec('Crypt_GPG') }
        it { is_expected.to contain_exec('pip install importlib') }
      end
    end
  end
end
