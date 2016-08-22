require 'spec_helper'
describe 'misp' do

  context 'with defaults for all parameters' do
    it { should contain_class('misp') }
  end
end
