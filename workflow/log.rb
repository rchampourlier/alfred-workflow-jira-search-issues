def log(message)
  log_path = File.expand_path('/var/tmp/alfred.log', __FILE__)
  file = File.open log_path, 'w+'
  file.puts message
  file.close
end
