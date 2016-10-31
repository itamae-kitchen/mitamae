iterations = ENV['MITAMAE_BENCH_ITERATIONS'].to_i

iterations.times do |i|
  file "/tmp/mitamae-bench-#{i}" do
    action :delete
  end
end
