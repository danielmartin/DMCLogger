# -*- coding: utf-8 -*-
Pod::Spec.new do |s|
  s.name             = "DMCLogger"
  s.version          = "0.1.0"
  s.summary          = "Lightweight logging library with focus on extensibility."
  s.description      = <<-DESC
                       DMCLogger is a logging library written in Objective C that is focused on providing just the functionality you need to get the work done. It is also based on convenient abstractions in order to be extensible and simple to understand.
                       DESC
  s.homepage         = "https://github.com/danielmartin/DMCLogger"
  s.license          = 'MIT'
  s.author           = { "Daniel Martín" => "mardani29@yahoo.es" }
  s.source           = { :git => "https://github.com/danielmartin/DMCLogger.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dmartincy'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'DMCLogger/Classes/**/*.{h,m}'

  s.public_header_files = 'DMCLogger/Classes/**/*.h'
end
