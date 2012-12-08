$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'vendor/ankusa/lib')

require 'ankusa'
require 'ankusa/memory_storage'
require_relative 'sample'

module Classifier
  class << self
    # Returns a new Proc that will initialize a classifier.
    def fetch(laplace=0, atomizer=:unigram)
      Proc.new {
        Ankusa::la_place = laplace
        Ankusa::atomizer = atomizer
        Ankusa::NaiveBayesClassifier.new(Ankusa::MemoryStorage.new)
      }
    end

    # Train the classifier on a set of samples.
    def train_up(classifier, samples)
      samples.each do |s|
        classifier.train s.kind, s.value
      end
    end

    # Save the classifier to disk, so we don't have to train again.
    def save(classifier, destination)
      File.open(destination, 'w') { |f| f.puts Marshal.dump(classifier) }
    end

    # Load a classifier or other object from disk.
    def load(filename)
      Marshal.load(File.read(filename))
    end
  end
end
