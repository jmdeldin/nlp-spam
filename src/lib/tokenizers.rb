# List of all available tokenizers
def tokenizers(which=nil)
  kinds = {
    :words => [:unigram, :bigram, :trigram],
    :chars => (1..5).to_a,
    :phono => [:metaphone, :bimetaphone],
  }

  if which
    kinds[which]
  else
    kinds.values.flatten
  end
end

def smoothers
  (0..1)
end

def headers
  puts %w(tokenizer lp acc err prec recall tp tn fp fn total).join(',')
end

def print_row(tokr, lp, mat)
  a = [tokr, lp] + mat.to_list
  puts a.join(',')
end
