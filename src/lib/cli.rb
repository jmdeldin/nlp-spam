def usage(file, args)
  abort "Usage: #{File.basename(file)} #{args}"
end

# Load training data into an array
def load_dir(dir, klass)
  files = Dir[File.join(dir, '*.html')]
  out = []

  Parallel.map(files, :in_threads => 200) do |f|
    body = File.read(f)
    out << Sample.new(body, klass, f)
  end

  out
end
