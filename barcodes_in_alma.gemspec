# frozen_string_literal: true

require_relative 'lib/barcodes_in_alma/version'

Gem::Specification.new do |spec|
  spec.name = 'barcodes_in_alma'
  spec.version = BarcodesInAlma::VERSION
  spec.authors = %w[regineheberlein maxkadel]
  spec.email = ['regineheberlein@gmail.com', 'mkadel@princeton.edu']

  spec.summary = 'Compare a barcodes report from Alma with a barcodes array to avoid sending a barcode that already exists in Alma.'
  spec.homepage = 'https://www.github.com/pulibrary/barcodes_in_alma'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'csv'
  spec.add_dependency 'net-sftp'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
