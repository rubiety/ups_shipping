# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ups_shipping/version"

Gem::Specification.new do |s|
  s.name        = "ups_shipping"
  s.version     = UpsShipping::VERSION
  s.author      = "Ben Hughes"
  s.email       = "ben@railsgarden.com"
  s.homepage    = "http://github.com/rubiety/ups_shipping"
  s.summary     = "A library for using the UPS Shipping XML API."
  s.description = "Provides a Ruby abstraction for the UPS Shipping Services API, which is XML based."
  
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
