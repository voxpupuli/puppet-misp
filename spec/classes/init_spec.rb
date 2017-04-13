require 'spec_helper'

describe 'misp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('Misp') }
      it { is_expected.to contain_class('Misp::Dependencies') }
      it { is_expected.to contain_class('Misp::Install') }
      it { is_expected.to contain_class('Misp::Config') }
      it { is_expected.to contain_class('Misp::Service') }
    end
  end
end
