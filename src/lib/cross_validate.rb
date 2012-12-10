require 'parallel'
require_relative 'sample'
require_relative 'confusion'

# Cross-validates a classifier
#
module CrossValidate
  class << self
    # Performs k-fold cross-validation and returns a confusion matrix.
    #
    # The algorithm is as follows (Mitchell, 1997, p147):
    #
    #   partitions = partition data into k-equal sized subsets (folds)
    #   for i = 1 -> k:
    #     T = data \ partitions[i]
    #     train(T)
    #     classify(partitions[i])
    #   output confusion matrix
    #
    # k = number of folds as a percentage (e.g., 10 == 10% of data is used for testing)
    def run(data, classifier_proc, k=10)
      confusion = Confusion.new
      k = data.size / k # as a percentage
      partitions = data.each_slice(k).to_a

      results = Parallel.map_with_index(partitions, :in_processes => 6) do |part, i|
        # Array#rotate puts the element i first, so all we have to do is rotate
        # then remove that element to get the training set. Array#drop does not
        # mutate the original array either. Array#flatten is needed to coalesce
        # our list of lists into one list again.
        training = partitions.rotate(i).drop(1).flatten

        # setup a new classifier
        classifier = classifier_proc.call()

        # train it
        training.each { |s| classifier.train s.kind, s.value }

        # fetch confusion keys
        o = []
        part.each do |x|
          prediction = classifier.classify x.value
          o << confusion.key_for(prediction, x.kind)
        end
        o
      end

      # count our keys
      results.each { |set| set.each { |key| confusion[key] += 1 } }

      confusion.compute
    end

    # Returns the confusion matrix key for a predicted value and the actual.
    def key_for(predicted, actual)
      if actual == :spam
        predicted == :spam ? :true_pos : :false_neg
      elsif actual == :ham
        predicted == :ham ? :true_neg : :false_pos
      end
    end
  end
end
