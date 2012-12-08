require 'parallel'
require_relative 'sample'

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
      confusion = {
        :true_pos  => 0, # spam
        :true_neg  => 0, # ham
        :false_pos => 0, # ham marked as spam
        :false_neg => 0, # spam marked as ham
      }

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
          o << key_for(prediction, x.kind)
        end
        o
      end

      # count our keys
      results.each { |set| set.each { |key| confusion[key] += 1 } }

      confusion.tap { |mat|
        mat[:total]     = mat.values.reduce(:+)
        mat[:accuracy]  = (mat[:true_pos] + mat[:true_neg]) / Float(mat[:total])
        mat[:error]     = ((1.0 - mat[:accuracy]) * 100).round(2)
        mat[:precision] = mat[:true_pos] / Float(mat[:true_pos] + mat[:false_pos])
        mat[:recall]    = mat[:true_pos] / Float(mat[:true_pos] + mat[:false_neg])
      }
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
