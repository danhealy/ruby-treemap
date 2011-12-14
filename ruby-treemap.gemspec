$:.unshift './lib'

require 'treemap/version'

Gem::Specification.new do |s|
    s.platform = Gem::Platform::RUBY

    s.name = 'ruby-treemap'
    s.summary = "Treemap visualization in ruby"
    s.description = %q{Treemap visualization in ruby}
    s.version = Treemap::VERSION
    s.author = "Andrew Bruno"
    s.email = "aeb@qnot.org"
    s.homepage = "http://rubytreemap.rubyforge.org/"

    s.has_rdoc = true
    s.extra_rdoc_files = [ "README", "EXAMPLES" ]
    s.rdoc_options = [ "--main", "README" ]
    s.requirements << 'none'

    s.require_path = 'lib'
    s.autorequire = 'treemap'
    s.add_dependency 'rmagick'

    s.files = [ "Rakefile", "TODO", "EXAMPLES", "README", "ChangeLog", "COPYING"]
    s.files = s.files + Dir.glob( "lib/**/*" ).delete_if { |item| item.include?( "\.svn" ) }
    s.files = s.files + Dir.glob( "test/**/*" ).delete_if { |item| item.include?( "\.svn" ) }
end

