require 'rbconfig'
# ruby 1.8.7 doesn't define RUBY_ENGINE
ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
ruby_version = RbConfig::CONFIG["ruby_version"]
path = File.expand_path('..', __FILE__)
$:.unshift "#{path}/"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-18/2.4.0-static/ffi-1.11.3"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/ffi-1.11.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rb-fsevent-0.10.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rb-inotify-0.10.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/listen-3.2.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/repla-0.10.4/lib"
