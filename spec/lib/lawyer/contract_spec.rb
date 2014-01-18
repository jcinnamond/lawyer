class TestContract < Lawyer::Contract
  confirm :ping
end

describe TestContract do
  before :each do
    # Stop modifications to the TestObject from leaking into other specs.
    Object.send(:remove_const, :TestObject) if Object.const_defined?(:TestObject)
    class TestObject; end
  end

  describe "#check!" do
    context "with a compliant object" do
      before :each do
        # Reopen the class and define the required method
        class TestObject; def ping; end; end
      end

      it "does not raise an exception when checking a class" do
        expect { TestContract.check!(TestObject) }.not_to raise_error
      end

      it "does not raise an exception when checking an object" do
        expect { TestContract.check!(TestObject.new) }.not_to raise_error
      end
    end

    context "with a non-compliant object" do
      it "raises a BrokenContract exception when checking a class" do
        expect { TestContract.check!(TestObject) }.to raise_error(Lawyer::BrokenContract)
      end

      it "raises a BrokenContract exception when checking an object" do
        expect { TestContract.check!(TestObject.new) }.to raise_error(Lawyer::BrokenContract)
      end

      describe "the exception" do
        before :each do
          begin
            TestContract.check!(TestObject)
          rescue Lawyer::BrokenContract => e
            @exception = e
          end
        end

        it "includes the offending class and contract" do
          expect(@exception.to_s).to include("TestObject does not implement <TestContract>\n")
        end

        it "includes the missing method details in the exception" do
          expect(@exception.to_s).to include("\t(1 missing method)\n\t[missing] ping\n")
        end
      end
    end
  end
end
