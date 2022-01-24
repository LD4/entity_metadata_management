require 'emm_theme'

namespace :test do
  desc 'Check html'
  task :html do
    opts = {
      check_html: true,
      assume_extension: true,
      validation: {
        report_mismatched_tags: true,
        report_invalid_tags: true
      },
      checks_to_ignore: ['LinkCheck']
    }
    HTMLProofer.check_directory(SITE_DIR, opts).run
  end

  namespace :links do
    desc 'Check for internal link errors'
    task :internal do
      puts 'Checking for internal link errors'
      opts = {
        checks_to_ignore: ['ImageCheck', 'HtmlCheck', 'ScriptCheck'],
        disable_external: true,
        internal_domains: ['localhost:4000']
      }
      HTMLProofer.check_directory(SITE_DIR, opts).run
    end

    desc 'Check for link errors'
    task :link_errors do
      puts 'Checking for link errors in sites'
      opts = {
        checks_to_ignore: ['ImageCheck', 'HtmlCheck', 'ScriptCheck'],
        url_ignore: [/^((?!emm\.io).)*$/, 'github'] # temporarily ignore emm.io github repo errors
      }
      HTMLProofer.check_directory(SITE_DIR, opts).run
    end

    desc 'Check for external link rot'
    task :external do
      puts 'Checking for external link errors'
      opts = {
        external_only: true,
        http_status_ignore: [429],
        enforce_https: true,
        only_4xx: true,
        checks_to_ignore: ['ImageCheck', 'HtmlCheck', 'ScriptCheck'],
        url_ignore: [/.*emm\.io.*/]
      }
      HTMLProofer.check_directory(SITE_DIR, opts).run
    end

    desc 'Run rspec tests (if they exist)'
    task :spec do

    end
  end
end
