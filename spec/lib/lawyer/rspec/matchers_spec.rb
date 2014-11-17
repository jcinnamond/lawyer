require 'lawyer/rspec'

RSpec.describe Lawyer::RSpec::Matchers do
  include Lawyer::RSpec::Matchers
  let(:subject) { double("Module", name: "Module") }
  let(:contract) { double("contract", check!: true, name: "Contract") }

  it "defines 'implement'" do
    expect(subject).to implement(contract)
  end

  it "calls checks the subject against the contract" do
    expect(contract).to receive(:check!).with(subject)
    expect(subject).to implement(contract)
  end

  context "with violations" do
    let(:broken_contract) { Lawyer::BrokenContract.new(subject, contract, []) }

    before :each do
      allow(contract).to receive(:check!).and_raise(broken_contract)
    end

    it "fails the matcher" do
      expect(subject).not_to implement(contract)
    end
  end
end
