require File.dirname(__FILE__) + '/string'
require File.dirname(__FILE__) + '/class'
require File.dirname(__FILE__) + '/module'
require File.dirname(__FILE__) + '/object'
require File.dirname(__FILE__) + '/array'
require File.dirname(__FILE__) + '/hash'

if defined? IRONRUBY_VERSION
  require File.dirname(__FILE__) + '/system/string'
  require File.dirname(__FILE__) + '/system/type'
end