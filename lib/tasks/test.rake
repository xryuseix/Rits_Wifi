## -----*----- テストスクリプト -----*----- ##

scripts = Dir.glob('./test/*.rb')

namespace :test do
  scripts.each do |script|
    name = File.basename(script, ".rb")
    desc "Execute Test Script: #{name}"
    task name.to_sym do
      require script
    end
  end
end