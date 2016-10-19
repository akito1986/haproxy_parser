Dir.glob(File.dirname(__FILE__) + "/builders/*.rb").each do |f|
  require "haproxy_parser/builders/" + File.basename(f, ".*")
end
