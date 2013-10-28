module Parser
  class Zl < JobParser
    def total_num
      @doc.css('.currentsearch span em').text.to_i
    end

    def parse
      @doc.css('.search-result-cont .search-result-tab .Jobname a').each do |p|
        job_url = p.attr('href')
        job_doc = to_doc(to_html(job_url))
        job_doc.css(".terminalpage .terminalpage-left").map do |p|
          begin
            left = p.css('.top-left')
            #city_url = left.css("span#positionCityCon a").attr('href').content rescue nil
            #city_name = left.css("span#positionCityCon a").text rescue nil
            table = left.css("table:first")
            company_elem = table.css("tr:eq(2) h2 a")
            job = Job.new(
                id: url.match(/\d+/).to_a.first,
                name: table.css("tr:first h1").text,
                content: p.css("div:eq(2) .terminalpage-content").text,
                url: job_url,
                html: html,
                publishing_at: p.css('#span4freshdate').text,
                company_url: company_elem.attr('href').content,
                recruited_at: Time.new
            )

            company = Company.new(name: company_elem.text.strip, url: company_elem.attr('href').content)
            industries = table.css("tr:last td:last a").each do |i|
              id = i.attr('href').match(/\d+/).to_a.first
              Industry.new(id: id, name: i.text, url: i.attr('href'))
            end
            table2 = left.css('table:last')
            job_types = table2.css("tr:last td:last a").each do |t|
              JobType.new({url: t.attr('href'), name: t.text})
            end
            [job,company,industries,job_types]
          rescue
            puts 'parse error:' + @url
            []
          end
        end
      end
    end
  end
end