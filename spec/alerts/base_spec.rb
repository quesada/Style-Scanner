require "spec_helper"
module Style
  module Alerts
    describe Base do
      let(:sentence) {Sentence.new("Dinosaurs really like 5 star dinners")}
      subject {Base.new(sentence, "really")}
      it "has a reference to a sentence" do
        subject.sentence.class == Sentence
      end
      it "knows its offending word" do
        subject.offending_word.should == "really"
      end
    end
  end
end
