require 'active_support/core_ext/string/multibyte'
require 'delegate'
module Fuzzily
  class String < SimpleDelegator

    def trigrams
      return [] if __getobj__.nil?
      normalized = self.normalize
      number_of_trigrams = normalized.length - 2
      trigrams = (0..number_of_trigrams).map { |index| normalized[index,2] }.uniq
    end

    def scored_trigrams
      trigrams.map { |t| [t, self.length] }
    end

    protected

    # Remove accents, downcase, replace spaces and word start with '*',
    # return list of normalized words
    def normalize
      ActiveSupport::Multibyte::Chars.new(self).
        mb_chars.normalize(:kd).downcase.to_s.
        gsub(/[а-я][a-z][0-9]/,' ').
        gsub(/\s+/,'*')
    end
  end
end
