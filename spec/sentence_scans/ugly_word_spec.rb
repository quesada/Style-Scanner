require "spec_helper"
module Style
  module SentenceScans
    describe UglyWord do
      let(:utilize) {Sentence.new("We will utilize these apples.")}
      let(:utilize_uppercase) {Sentence.new("We Utilize Kleenex")}
      context "#scan" do
        it "recommends you replaces utilize with use" do
          should_alert utilize, Alerts::UglyWord, "We will use these apples."
        end
        it "handles uppercase" do
          should_alert utilize_uppercase, Alerts::UglyWord, "We Use Kleenex"
        end
      end
    end
  end
end
