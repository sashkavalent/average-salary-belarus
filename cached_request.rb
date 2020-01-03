class CachedRequest
  def self.run(url, path)
    full_path = "cache/#{path}"
    if File.exist?(full_path)
      File.read(full_path)
    else
      puts "request to #{url}"
      Net::HTTP.get(URI(url)).tap { |rates| File.write(full_path, rates) }
    end
  end
end
