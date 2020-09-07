RSpec.describe Bittn do

  it "does something useful" do
    class Lang < Bittn::BaseLang
      def initialize
        @name = "test"
      end
    end
    lang = Lang.new
    
    lang.name=="test"&&lang.version==nil
  end
end
