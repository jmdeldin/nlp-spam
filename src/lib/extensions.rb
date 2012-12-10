class String
  def to_words
    scan(/[a-z']/i)
  end
end
