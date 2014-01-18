describe Module do
  describe "#implements" do
    it "checks the module against the contract" do
      class A; end

      contract = double("contract")
      expect(contract).to receive(:check!).with(A)
      A.implements(contract)
    end
  end
end
