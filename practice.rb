numbers = [*1..30]

numbers.each do |number|
  if number % 15 == 0
    puts "fizzbuzz"
  elsif number % 3 == 0
    puts "fizz"
  elsif number % 5 == 0
    puts "buzz"
  else
    puts number
  end
end
