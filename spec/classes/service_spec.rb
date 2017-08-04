require 'spec_helper'

describe 'misp::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Service').that_requires('Class[Misp::Config]') }

      it do
        is_expected.to contain_service('rh-php56-php-fpm').
          with_ensure('running').
          with_enable('true')
      end

      it do
        is_expected.to contain_service('haveged').
          with_ensure('running').
          with_enable('true')
      end

      context 'With default values' do
        it do
          is_expected.to contain_class('redis')
        end

        it do
          is_expected.to contain_exec('start bg workers').
            with_command(%r{(apache).*(/var/www/MISP/)}).
            with_unless(%r{(apache).*(/var/www/MISP/)}).
            with_user('root').
            with_group('apache')
        end

        it do
          is_expected.to contain_exec('restart bg workers').
            with_command(%r{(apache).*(/var/www/MISP/)}).
            with_user('root').
            with_group('apache').
            with_refreshonly('true').
            that_subscribes_to('Exec[CakeResque install]')
        end
      end
    end
  end
end
