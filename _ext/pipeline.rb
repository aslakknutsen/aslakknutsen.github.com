require 'bootstrap-sass'
require 'gist'
require 'restclient_extensions'
require 'restclient_extensions_enabler'

Awestruct::Extensions::Pipeline.new do
   github_auth = Awestruct::Extensions::Auth.new('.github-auth')

  extension Awestruct::Extensions::RestClientExtensions::EnableAuth.new([github_auth])
  extension Awestruct::Extensions::RestClientExtensions::EnableGetCache.new
  extension Awestruct::Extensions::RestClientExtensions::EnableJsonConverter.new


  extension Awestruct::Extensions::Gist.new( 'aslakknutsen') 
  extension Awestruct::Extensions::Posts.new( '/blog' ) 
  # extension Awestruct::Extensions::Indexifier.new

  helper Awestruct::Extensions::GoogleAnalytics
end
