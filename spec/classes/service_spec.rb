# frozen_string_literal: true

require 'spec_helper'

describe 'misp::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Service').that_requires('Class[Misp::Config]') }

      context 'With default values' do
        it { is_expected.to contain_file_line('php max_execution_time') }
        it { is_expected.to contain_file_line('php memory_limit') }
        it { is_expected.to contain_file_line('php post_max_size') }
        it { is_expected.to contain_file_line('php upload_max_filesize') }
        it { is_expected.to contain_file_line('php-fpm enable rh-python36') }
        it { is_expected.to contain_file_line('php-fpm no clear_env') }
        it { is_expected.to contain_file_line('php-fpm env[LD_LIBRARY_PATH]') }
        it { is_expected.to contain_file_line('php-fpm env[MANPATH]') }
        it { is_expected.to contain_file_line('php-fpm env[PATH]') }
        it { is_expected.to contain_file_line('php-fpm env[PKG_CONFIG_PATH]') }
        it { is_expected.to contain_file_line('php-fpm env[XDG_DATA_DIRS]') }

        it do
          is_expected.to contain_service('rh-php72-php-fpm').
            with_ensure('running').
            with_enable('true')
        end

        it do
          is_expected.to contain_service('haveged').
            with_ensure('running').
            with_enable('true')
        end

        it do
          is_expected.to contain_service('misp-workers').
            with_ensure('running').
            with_enable('true')
        end

        it do
          is_expected.to contain_class('redis')
        end
      end
    end
  end
end
