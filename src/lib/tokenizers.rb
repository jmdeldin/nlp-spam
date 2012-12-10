# List of all available tokenizers
def tokenizers
  [:unigram, :bigram, :trigram, :metaphone, :bimetaphone] + (1..6).to_a
end

def smoothers
  (0..1)
end

def headers
  puts %w(tokenizer lp acc err prec recall tp tn fp fn total).join(',')
end
