module Parser
  class Zl < JobParser
    def total_num
      @doc.css('.currentsearch span em').text.to_i
    end

    def parse
      @doc.css('.search-result-cont .search-result-tab .Jobname a').map do |p|
        job_url = p.attr('href')
        #66
        job_url.length > 76 ? job2(job_url) : job1(job_url)
      end
    end

    def job1(job_url)
      job_doc = to_doc(to_html(job_url))
      begin
        p =job_doc.css(".terminalpage .terminalpage-left")
          left = p.css('.top-left')
          #city_url = left.css("span#positionCityCon a").attr('href').content rescue nil
          #city_name = left.css("span#positionCityCon a").text rescue nil
          table = left.css("table:first")
          company_elem = table.css("h2 a")
          job_info = left.css("table:last")
          job = Job.new(
              id: url.match(/\d+/).to_a.first,
              name: table.css("tr:first h1").text,
              content: p.css("div:eq(2) .terminalpage-content").text,
              url: job_url,
              experience: job_info.css('tr:first td:eq(2)').text.strip,
              kind: job_info.css('tr:first td:eq(4)').text.strip,
              education: job_info.css('tr:eq(2) td:eq(2)').text.strip,
              management: job_info.css('tr:eq(2) td:eq(4)').text.strip,
              salary: job_info.css('tr:eq(3) td:eq(2)').text.strip,
              people_num: job_info.css('tr:eq(3) td:eq(4)').text.strip,
              address: job_info.css('tr:eq(4) td:eq(2)').text.strip,
              publishing_at: p.css('#span4freshdate').text,
              recruited_at: Time.new
          )

          company = Company.new(name: company_elem.text.strip,
                                url: company_elem.attr('href').content)
          industries = table.css("tr:last td:last a").map do |i|
            id = i.attr('href').match(/\d+/).to_a.first
            Industry.new(id: id, name: i.text, url: i.attr('href'))
          end
          job.company=company
          company.industries=industries
          table2 = left.css('table:last')
          job_types = table2.css("tr:last td:last a").map do |t|
            JobType.new({url: t.attr('href'), name: t.text})
          end
          job.job_types=job_types
          [job, company, industries, job_types]

        rescue
          puts 'parse error:' + job_url
          []
        end
    end

    def job2(job_url)
      begin
        doc = to_doc(to_html(job_url))
        main = doc.css('.urgent-terminalpage-right-main')
        intro = main.css('.top-left')
        job_info = intro.css('.terminalpage-table:eq(2)')
        job = Job.new(name: intro.css('h1').text.strip,
                      content: main.css('.terminalpage-content').text,
                      url: job_url,
                      experience: job_info.css('tr:first td:eq(2)').text.strip,
                      kind: job_info.css('tr:first td:eq(4)').text.strip,
                      education: job_info.css('tr:eq(2) td:eq(2)').text.strip,
                      management: job_info.css('tr:eq(2) td:eq(4)').text.strip,
                      salary: job_info.css('tr:eq(3) td:eq(2)').text.strip,
                      people_num: job_info.css('tr:eq(3) td:eq(4)').text.strip,
                      address: job_info.css('tr:eq(4) td:eq(2)').text.strip,
                      publishing_at: main.css('#span4freshdate').text.strip,
                      recruited_at: Time.new)
        company_info = intro.css('.terminalpage-table:first')
        company = Company.new(name: company_info.css('h2 a').text.strip, url: intro.css('h2 a').attr('href').content)
        industries = company_info.css('tr:last a').map { |a| Industry.new(name: a.text, url: a.attr('href')) }
        company.industries = industries
        job_types =job_info.css('tr:last td:last a').map { |a| JobType.new({name: a.text, url: a.attr('href')}) }
        job.job_types =job_types
        [job, company, industries, job_types]
      rescue
        puts 'parse error:' + job_url
        []
      end
    end
  end
end