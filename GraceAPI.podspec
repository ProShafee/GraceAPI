Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "GraceAPI"
  spec.version      = "1.0.1"
  spec.summary      = "Gracefully handling API Calls"
  spec.description  = "GraceAPI is a lightweight framework designed to simplify API requests with robust error handling. It supports multiple HTTP methods and ensures seamless integration by managing authentication, network failures, client errors, server errors, and decoding issues, providing a reliable, scalable solution for API communication."

  spec.homepage     = "https://github.com/ProShafee/GraceAPI"
  spec.license      = "MIT"
  spec.author             = { "Shafee" => "shafeerehman57@gmail.com" }
  spec.platform     = :ios, "16.0"
  spec.swift_versions = "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  # spec.visionos.deployment_target = "1.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/ProShafee/GraceAPI.git", :tag => spec.version.to_s }
  spec.source_files  = "GraceAPI/**/*.{swift}"

end
