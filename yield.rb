def hello
  puts "hello"
  yield
  puts "welcome"
end

hello do
  puts "audacia"
  puts "Today I am cold"
end

# hello {puts "audacia"; puts "Today I am cold"}
