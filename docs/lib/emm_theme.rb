require 'fileutils'
require 'html-proofer'
require 'yaml'

SITE_DIR = './_site'
CONFIG   = YAML.load_file './_config.yml'
SITE_ID  = ENV['SITE_ID'] || CONFIG.fetch('site_id', 'root')
LIVE_PATH  = ENV['LIVE_PATH'] || CONFIG.fetch('live_path', '/missing')

module EmmTheme ; end
