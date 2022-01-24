require 'emm_theme'

namespace :build do
  def build(dest=nil, baseurl=nil)
    sh "bundle exec jekyll clean"
    cmd = "bundle exec jekyll build"
    cmd += " -d '#{dest}'" unless dest.nil?
    cmd += " --baseurl '#{baseurl}'" unless baseurl.nil?
    sh cmd
  end

  desc 'Clean and build with branch live URL overrides'
  task :live do
    baseurl = "#{LIVE_PATH}"
    dest    = SITE_DIR + baseurl

    build dest=dest, baseurl=baseurl
  end

  desc 'Clean and build with branch preview URL overrides'
  task :preview do
    branch = `git rev-parse --abbrev-ref HEAD`.strip
    baseurl = "/#{SITE_ID}/#{branch}"
    dest    = SITE_DIR + baseurl

    build dest=dest, baseurl=baseurl
  end

  desc 'Clean and build with CI test overrides'
  task :ci do
    baseurl = '/test/extra-test'
    dest    = SITE_DIR + baseurl

    build dest=dest, baseurl=baseurl
  end

  desc 'Clean and build with no overrrides'
  task :default do
    build
  end
end
