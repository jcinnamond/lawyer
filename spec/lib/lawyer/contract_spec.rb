class TestContract < Lawyer::Contract
  confirm :pang => -1
  confirm :ping
  confirm :pong => 2
  confirm :pung => [:name, :size]
end

class TestInitialize < Lawyer::Contract
  confirm :initialize => [:arg]
end

describe TestInitialize do
  before :each do
    Object.send(:remove_const, :TestObjectNew) if Object.const_defined?(:TestObjectNew)
  end

  it "does not raise an exception is the contact is satisified" do
    class TestObjectNew
      def initialize(arg:)
      end
    end

    expect { TestInitialize.check!(TestObjectNew) }.not_to raise_error
  end

  it "raises an exception if the signature is wrong" do
    class TestObjectNew; end

    expect { TestInitialize.check!(TestObjectNew) }.to raise_error(Lawyer::BrokenContract)
  end
end


describe TestContract do
  before :each do
    # Stop modifications to the TestObject from leaking into other specs.
    Object.send(:remove_const, :TestObject) if Object.const_defined?(:TestObject)
    class TestObject;
      def pang(*args); end
      def pong(a1); end
      def pung(name:, hats:); end
    end
  end

  describe "#check!" do
    context "with a compliant object" do
      before :each do
        # Reopen the class and define the required methods
        class TestObject;
          def pang(*args); end
          def ping; end
          def pong(a1, a2); end
          def pung(name:, size:); end
        end
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
          expect(@exception.to_s).to include("\t(1 method missing)\n\t[missing] ping\n")
        end

        it "includes the incorrect arity details in the exception" do
          expect(@exception.to_s).to include("\t(1 method with the wrong arity)\n\t[wrong arity] pong (takes 1, requires 2)\n")
        end

        it "includes required argument mismatch details in the exception" do
          expect(@exception.to_s).to include("\t(1 method with the wrong signature)\n\t[wrong signature] pung (missing [:size], extra [:hats])\n")
        end
      end
    end
  end
end
