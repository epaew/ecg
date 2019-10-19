# frozen_string_literal: true

require 'simplecov'
require 'simplecov-console'
require 'test/unit'
require 'test/unit/rr'

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start { add_filter '/test/' }

require 'bundler/setup'
require 'ecg'
