require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  @@all = []

  def self.all 
    @@all
  end

    def self.scrape_index_page(index_url)
      html = open(index_url)
      doc = Nokogiri::HTML(html)
      doc.css("div.roster-cards-container").css(".student-card").each do|student| 
          student_properties = {}
          student_properties[:name] = student.css("h4.student-name").text
          student_properties[:location] = student.css("p.student-location").text
          student_properties[:profile_url]  = student.css("a").attribute("href").text
          self.all << student_properties
        end
        
        self.all
        
    end
      
    def self.scrape_profile_page(profile_url)
        html = open(profile_url)
        doc = Nokogiri::HTML(html)
        # social_network_link will scrape profile webpages for links
        # [0] - twitter
        # [1] - linkedIn
        # [2] - github
        # [3] - youTube

        social_network_link = doc.css("div.vitals-container").css(".social-icon-container a")
        social_network_arrays = social_network_link.collect{|link| link.attribute("href").value}
        
        profile = {}
        social_network_arrays.each do |link| 
          if link.include?("twitter")
            profile[:twitter] = link
          elsif link.include?("linkedin")
            profile[:linkedin] = link
          elsif link.include?("github")
            profile[:github] = link
          else
            profile[:blog] = link
          end
        end
        profile[:profile_quote] = doc.css(".vitals-text-container").css(".profile-quote").text
        profile[:bio] = doc.css("div.bio-block.details-block").css(".description-holder p").text
        
        profile
        # binding.pry


      # {
      #   :twitter=>"http://twitter.com/flatironschool",
      #   :linkedin=>"https://www.linkedin.com/in/flatironschool",
      #   :github=>"https://github.com/learn-co",
      #   :blog=>"http://flatironschool.com",
      #   :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
      #   :bio=> "I'm a school"
      # }
    end
    
  end
  
  # scraper = Scraper.new
  # Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/ryan-johnson.html")