require 'spec_helper'

describe 'misp::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp::Service').that_requires('Class[Misp::Config]') }
      it { is_expected.to contain_service('rh-php56-php-fpm').with(
  	    'ensure' => 'running',
  	    'enable' => 'true',
  	  ) }
      it { is_expected.to contain_service('haveged').with(
  	    'ensure' => 'running',
  	    'enable' => 'true',
  	  ) }
      it { is_expected.to contain_service('redis').with(
  	    'ensure' => 'running',
  	    'enable' => 'true',
  	  ) }
      context "With default values" do
        it { is_expected.to contain_exec('start bg workers') }
        it { is_expected.to contain_exec('restart bg workers').with(
          'refreshonly' => 'true',
        ).that_subscribes_to('Exec[CakeResque install]') }
      end
    end
  end
end
