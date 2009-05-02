# Amok -- a compact mock library

# Copyright (C) 2008 Christian Neukirchen <purl.org/net/chneukirchen>
#
# Amok is freely distributable under the terms of an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.

# Moq -- The simplest mocking library for .NET 3.5 and Silverlight with deep C# 3.0 integration
#
# Copyright (c) 2007, Moq Team
# http://code.google.com/p/moq/
# All rights reserved.
#
# Redistribution and use in source and binary forms,
# with or without modification, are permitted provided
# that the following conditions are met:
#
#    * Redistributions of source code must retain the
#    above copyright notice, this list of conditions and
#    the following disclaimer.
#
#    * Redistributions in binary form must reproduce
#    the above copyright notice, this list of conditions
#    and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#    * Neither the name of the Moq Team nor the
#    names of its contributors may be used to endorse
#    or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# [This is the BSD license, see
#  http://www.opensource.org/licenses/bsd-license.php]

# irmoq -- A Friendship between Amok and Moq
#
# Copyright (c) 2009, Moq Team
# http://github.com/casualjim/irmoq
# All rights reserved.
#
# Redistribution and use in source and binary forms,
# with or without modification, are permitted provided
# that the following conditions are met:
#
#    * Redistributions of source code must retain the
#    above copyright notice, this list of conditions and
#    the following disclaimer.
#
#    * Redistributions in binary form must reproduce
#    the above copyright notice, this list of conditions
#    and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#    * Neither the name of the irmoq Team nor the
#    names of its contributors may be used to endorse
#    or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# [This is the BSD license, see
#  http://www.opensource.org/licenses/bsd-license.php]



class IrMoq

  VERSION = '0.1'

  attr_reader :obj

  def self.with(obj)
    mock = new(obj)
    yield obj, mock
    mock.validate
  end

  def self.make(hash, &block)
    a = new(Object.new, &block)
    hash.each { |key, value| a.on(key) { value } }
    a.obj
  end

  @@uuid = 0
  def uuid
    @@uuid += 1
  end

  def initialize(obj, &block)
    @obj = obj
    @called = {}
    @previous = {}
    instance_eval(&block)  if block
  end


end