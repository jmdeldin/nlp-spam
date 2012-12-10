require_relative 'vendor/ankusa/lib/ankusa/stopwords'

class String
  def to_words
    scan(/[a-z']+/i)
  end
end

class Array
  def remove_stops
    reject { |w| Ankusa::STOPWORDS.include?(w) }
  end
end
