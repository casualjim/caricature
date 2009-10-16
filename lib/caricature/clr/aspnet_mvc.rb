load_assembly 'System.Web.Routing'
load_assembly 'System.Web.Mvc'
load_assembly 'System.Web.Abstractions'

include System::Web
include System::Web::Routing
include System::Web::Mvc

class String

  def to_url_filename
    return self.gsub(/\?.*/, '') if self =~ /\?/
    self
  end

  def to_qs_parameters
    if self =~ /\?/
      parameters = NameValueCollection.new
      self.split('?')[1].split("&").each do |pair|
        parts = pair.split('=')
        parameters.add pair.first, pair.last
      end
      return parameters
    end
    nil
  end

end

def http_context_isolation(url="")

  context = Caricature::Isolation.for(HttpContextBase)
  request = Caricature::Isolation.for(HttpRequestBase)
  response = Caricature::Isolation.for(HttpResponseBase)
  session = Caricature::Isolation.for(HttpSessionStateBase)
  server = Caricature::Isolation.for(HttpServerUtilityBase)

  context.when_receiving(:request).return(request)
  context.when_receiving(:response).return(response)
  context.when_receiving(:session).return(session)
  context.when_receiving(:server).return(server)

  setup_request_url(context.request, url) unless url.nil? or url.empty?

  context
end

def setup_request_url(request, url)
  raise ArgumentError.new("url should not be nil") if url.nil? or url.empty?
  raise ArgumentError.new("we expect a url to start with '~/'.") unless url =~ /^~\//

  request.when_receiving(:query_string).return(url.to_s.to_qs_parameters)
  request.when_receiving(:app_relative_current_execution_file_path).return(url.to_s.to_url_filename)
  request.when_receiving(:path_info).return("")
end