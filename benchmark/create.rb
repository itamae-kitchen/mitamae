iterations = ENV['MITAMAE_BENCH_ITERATIONS'].to_i

iterations.times do |i|
  file "/tmp/mitamae-bench-#{i}" do
    user ENV['USER']
    mode '777'
    content i.to_s
  end
end
