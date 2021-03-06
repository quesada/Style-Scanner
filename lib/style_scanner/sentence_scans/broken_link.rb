module StyleScanner
  module SentenceScans
    class BrokenLink < Base 

      URL_REGEX = /(?#Protocol)(?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?#Username:Password)(?:\w+:\w+@)?(?#Subdomains)(?:(?:[-\w]+\.)+(?#TopLevel Domains)(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum|travel|[a-z]{2}))(?#Port)(?::[\d]{1,5})?(?#Directories)(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?#Query)(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?#Anchor)(?:#(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)?/

        def scan
          links = sentence.scan(URL_REGEX)
          links.each do |url|
            begin
              attempt_to_visit_url(url)
              # socket error occurs if link is bad
            rescue SocketError, Errno::ECONNREFUSED
              create_problem("Url #{url} does not work")
            end
          end
        end

      private

      def attempt_to_visit_url(url)
        Net::HTTP.get_response(URI.parse(url))
      end

    end
  end
end
