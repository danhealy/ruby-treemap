require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'treemap'

CLEAN.include FileList['test/*.html', 'test/*.png', 'test/*.svg']
CLEAN.include 'docs'

desc 'list available tasks'
task :default do
    puts "Run 'rake --tasks' for the list of available tasks"
end

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'docs'
    rdoc.title    = "RubyTreemap"
    rdoc.options << "--all"
    rdoc.options << "-S"
    rdoc.options << "-N"
    rdoc.options << "--main=README"
    rdoc.rdoc_files.include("README", "EXAMPLES", "TODO", "ChangeLog", "lib/*.rb", "lib/**/*.rb")
end

desc "Run unit tests"
Rake::TestTask.new do |t|
    t.libs << "test"
    begin
        require 'RMagick'
        t.pattern = 'test/tc_*.rb'
    rescue LoadError
        t.test_files = ['tc_color.rb','tc_html.rb']
    end
    t.verbose = true
end

