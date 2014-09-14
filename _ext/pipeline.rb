require 'gist'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Gist.new( 'aslakknutsen') 
  extension Awestruct::Extensions::Posts.new( '/blog' ) 
  # extension Awestruct::Extensions::Indexifier.new

  helper Awestruct::Extensions::GoogleAnalytics
end
