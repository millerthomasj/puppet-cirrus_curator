require 'spec_helper'
describe 'cirrus_curator' do
  context 'with default values for all parameters' do
    it { should contain_class('cirrus_curator') }
  end
end
