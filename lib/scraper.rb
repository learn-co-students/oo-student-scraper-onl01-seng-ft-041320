require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = doc.css(".student-card")
    students.map do |student|
      {:name => student.css(".student-name").text,
      :location => student.css(".student-location").text,
      :profile_url => student.css("a").attribute("href").value}
    end
  end

  def self.scrape_profile_page(profile_url)
    new_hash = {}
    doc = Nokogiri::HTML(open(profile_url))
    social_media = doc.css(".social-icon-container a")
    social_media.each do |platform|
      url = platform.attribute("href").value
      #url = profile_url if url = "#" #flatiron same page link fix
      case platform.css(".social-icon").attribute("src").value
      when "../assets/img/twitter-icon.png"
        platform_name = :twitter
      when "../assets/img/linkedin-icon.png"
        platform_name = :linkedin
      when "../assets/img/github-icon.png"
        platform_name = :github
      when "../assets/img/rss-icon.png"
        platform_name = :blog
      end
      new_hash[platform_name] = url
    end
    new_hash[:profile_quote] = doc.css(".profile-quote").text
    new_hash[:bio] = doc.css(".bio-block .description-holder p").text

    new_hash
  end

end

# binding.pry
# 0

