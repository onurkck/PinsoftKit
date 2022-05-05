
Pod::Spec.new do |spec|

  spec.name         = "PinsoftKit"
  spec.version      = "0.3.0"
  spec.summary      = "PinsoftKit Logger"

  spec.description  = <<-DESC
	PinsoftKit Logger Framework
                   DESC

  spec.homepage     = "https://github.com/onurkck"

  spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  spec.author             = { "Onur Kucuk" => "onur.kucuk@pinsoft.ist" }
  
  spec.platform     = :ios, "13.0"

  spec.source       = { :http => "https://www.dropbox.com/s/2bhi6gf8u9z2vfo/PinsoftKit_v2.zip?dl=1" }

  spec.exclude_files = "Classes/Exclude"

  spec.ios.vendored_frameworks = "PinsoftKit.framework"


end
