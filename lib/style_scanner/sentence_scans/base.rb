module StyleScanner
  module SentenceScans
    class Base

      attr_reader :sentence

      def initialize(sentence)
        @sentence = sentence
      end

      def self.scan(sentence)
        new(sentence).scan
      end

      private

      def word_pairs
        # ruby searches for WORD_PAIRS on base class without the following line
        word_pairs = self.class::WORD_PAIRS
      end

      def replacement_word(offending_word)
        word_pairs[offending_word]
      end

      def tokenized_words
        words.map(&:tokenized).reject {|word| word == ""}
      end

      # We retokenize for the text case where no overall scanner is prepared
      def words
        sentence.tagged_words
      end

      def next_word(word)
        words.at(words.index(word) + 1)
      end

      def next_significant_word(word)
        possible_word = next_word(word)
        return next_significant_word(possible_word) if possible_word.adverb? || possible_word.preposition? || possible_word.determiner?
        possible_word
      end

      def already_has_that_problem_on_text(offending_text)
        sentence.find_problems_by_type(problem_class).any? do |problem|
          problem.on_text?(offending_text)
        end
      end

      def problem_class
        Problems.const_get(self.class.to_s.gsub("StyleScanner::SentenceScans::", ""))
      end

      def create_problem(offending_text)
        sentence.add_problem(problem_class.new(sentence, offending_text)) unless already_has_that_problem_on_text(offending_text)
      end

      class << self

         def load_file(filename)
           file_location = File.expand_path("../../../dictionaries/#{filename}", __FILE__)
           IO.read(file_location).split("\n")
         end

      end

    end
  end
end
