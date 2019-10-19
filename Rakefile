# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require_relative 'lib/ecg/version'

task default: :test

namespace :gem do
  desc 'build a gem package'
  task :build do
    sh 'gem build ecg.gemspec'
  end

  desc 'build a gem package'
  task push: :build do
    sh "gem push ecg-#{ECG::VERSION}.gem"
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end
