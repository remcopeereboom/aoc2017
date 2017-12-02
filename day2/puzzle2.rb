#################################
# To run: ruby puzzle1.rb input #
#################################

def find_div(row)
  (0...row.length).each do |i|
    ((i + 1)...row.length).each do |j|
      a = row[i]
      b = row[j]

      q, m = (a > b ? a.divmod(b) : b.divmod(a) )
      return q if m == 0
    end
  end
end

sum = 0
ARGF.each_line do |l|
  row = l.split.map(&:to_i)
  sum += find_div(row)
end

puts sum
