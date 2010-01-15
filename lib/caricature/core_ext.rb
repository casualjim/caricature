require File.dirname(__FILE__) + '/core_ext/string'
require File.dirname(__FILE__) + '/core_ext/class'
require File.dirname(__FILE__) + '/core_ext/module'
require File.dirname(__FILE__) + '/core_ext/object'
require File.dirname(__FILE__) + '/core_ext/array'
require File.dirname(__FILE__) + '/core_ext/hash'

if defined? IRONRUBY_VERSION
  require File.dirname(__FILE__) + '/core_ext/system/string'
  require File.dirname(__FILE__) + '/core_ext/system/type'
end