require 'benchmark'
require 'stringio'

require 'kramdown'
require 'bluecloth'
require 'maruku'
require 'rdiscount'
require 'bluefeather'

module MaRuKu::Errors
  def tell_user(s)
  end
end


RUNS=20

FILES=['mdsyntax.text', 'mdbasics.text']

puts "Running tests on #{Time.now.strftime("%Y-%M-%d")} under #{RUBY_DESCRIPTION}"

FILES.each do |file|
  data = File.read(File.join(File.dirname(__FILE__), file))
  puts
  puts "Test using file #{file} and #{RUNS} runs"
  Benchmark.bmbm do |b|
    b.report("Kramdown #{Kramdown::VERSION}") { RUNS.times { Kramdown::Document.new(data).to_html } }
    b.report("Maruku #{Maruku::VERSION}") { RUNS.times { Maruku.new(data, :on_error => :ignore).to_html } }
    b.report("BlueFeather #{BlueFeather::VERSION}") { RUNS.times { BlueFeather.parse(data) } }
    b.report("BlueCloth #{BlueCloth::VERSION}") { RUNS.times { BlueCloth.new(data).to_html } }
    b.report("RDiscount #{RDiscount::VERSION}") { RUNS.times { RDiscount.new(data).to_html } }
  end
end
