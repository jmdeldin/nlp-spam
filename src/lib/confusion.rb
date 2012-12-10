require_relative 'sample'

# Represents a confusion matrix
#
class Confusion < Hash
  def initialize
    [:true_pos, :true_neg, :false_pos, :false_neg].each do |k|
      store(k, 0)
    end
  end

  # Returns the confusion matrix key for a predicted value and the actual.
  def key_for(predicted, actual)
    if actual == :spam
      predicted == :spam ? :true_pos : :false_neg
    elsif actual == :ham
      predicted == :ham ? :true_neg : :false_pos
    end
  end

  def save_prediction(predicted, actual)
    self[key_for(predicted, actual)] += 1
  end

  def compute
    store :total,     values().reduce(:+)
    store :accuracy,  (fetch(:true_pos) + fetch(:true_neg)) / Float(fetch(:total))
    store :error,     ((1.0 - fetch(:accuracy)) * 100).round(2)
    store :precision, fetch(:true_pos) / Float(fetch(:true_pos) + fetch(:false_pos))
    store :recall,    fetch(:true_pos) / Float(fetch(:true_pos) + fetch(:false_neg))

    self
  end

  def to_list
    [:accuracy, :error, :precision, :recall, :true_pos, :true_neg, :false_pos,
      :false_neg, :total
    ].map { |f| fetch(f) }
  end
end
