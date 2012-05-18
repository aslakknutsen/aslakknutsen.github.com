require 'rubygems'
require 'rest-client'
require 'json'
require 'ostruct'

module Awestruct
    module Extensions
        GISTS_URL_TEMPLATE = 'https://api.github.com/users/%s/gists'

        class Gist

            def initialize(username, password = nil, output = '/blog')
                @username = username
                @password = password
                @output = output
            end

            def execute(site)
                @tmp_dir = File.join(site.tmp_dir, "gist")
                Dir.mkdir @tmp_dir unless File.exists? @tmp_dir

                #input_page = File.join( File.dirname(__FILE__), 'gist-template.html.haml' )
                filter_blog_gists(load_gists).each do |gist|

                    blog_file = nil
                    gist["files"].each{|key, value| 
                        blog_file = value if value["filename"] =~ /blog\..*/
                    }
                    temp_file_name = write_content(blog_file, gist["id"])

                    page = site.engine.load_page( temp_file_name )
                    page.author = gist["user"]["login"]
                    page.date = gist["created_at"]
                    page.title = gist["description"]
                    page.gist_source = gist["html_url"]
                    page.relative_source_path = "#{@output}/#{gist['id']}.html"
                    page.layout = "blog"

                    site.pages << page
                end
            end

            def filter_blog_gists(gists)
                gists.select do |gist|
                    contain_blog = false
                    gist["files"].each{|key, value| 
                        contain_blog = true if value["filename"] =~ /blog\..*/
                    }
                    contain_blog
                end
            end

            def load_gists()
                url = GISTS_URL_TEMPLATE % [ @username ]
                
                content = nil
                filename = File.join(@tmp_dir, "#{@username}.json")
                if File.exists? filename 
                    content = IO.read filename
                else
                    if @password.nil?
                        resource = RestClient::Resource.new(url) #, :user => @username, :password => @password)
                    else
                        resource = RestClient::Resource.new(url, :user => @username, :password => @password)
                    end
                    content = resource.get(:accept => 'application/json')
                    File.open(filename, 'w') do |f|
                        f.write content
                    end
                end
                    
                return JSON.parse content
            end

            def write_content(blog, id)
                 filename = File.join(@tmp_dir, "#{id}_#{blog['filename']}")
                 if !File.exists? filename
                    content = RestClient.get blog["raw_url"]
                    File.open(filename, 'w') do |f|
                        f.write content
                    end
                end
                return filename
            end
        end

    end
end