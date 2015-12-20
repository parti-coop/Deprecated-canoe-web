guard :minitest do
  watch(%r{^test/(.*)\/?test_(.*)\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/(spec|rails)_helper.rb$})       { "spec" }
  watch('spec/factories.rb')                     { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/features\/.+_spec\.rb$})
  watch(%r{^spec/support/(.*)_context\.rb})      { "spec/features" }
  watch(%r{^spec/support/(.*)\.rb})              { "spec" }
end
