# added to integrate with repl.it; repl only supports ruby 2.5.5 which does not include Array#intersection
class Array
  def intersection(other_array)
    inter_array = other_array.select { |el| self.include?(el) }.uniq
  end
end
