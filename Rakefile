# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create(:test) do |t|
  t.libs << 'test'
  t.test_globs = FileList['test/**/test_*.rb']
  t.verbose = false
end

task default: :test
