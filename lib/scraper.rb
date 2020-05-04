require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  attr_reader :scraped_students, :scraped_student

  def self.scrape_index_page(index_url)
    html = open("#{index_url}")
    doc = Nokogiri::HTML(html)
    @scraped_students = []
    doc.css(".roster-cards-container").each do |individual|
      individual.css(".student-card a").each do |student|
      #binding.pry

      @scraped_students <<  {
      :name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => student.attribute("href").value
      }
    end
  end
    @scraped_students
  end


  def self.scrape_profile_page(profile_url)
    html = open("#{profile_url}")
    doc= Nokogiri::HTML(html)
    @scraped_student = {}

    social = doc.css(".vitals-container .social-icon-container a")
    social.each do |element| 
      #binding.pry #iterate through each of the social elements and assign the keys if the item exists
      if element.attr('href').include?("twitter")
        @scraped_student[:twitter] = element.attr('href')
      elsif element.attr('href').include?("linkedin")
        @scraped_student[:linkedin] = element.attr('href')
      elsif element.attr('href').include?("github")
        @scraped_student[:github] = element.attr('href')
      elsif element.attr('href').end_with?("com/")
        @scraped_student[:blog] = element.attr('href')
      end
    end
    @scraped_student[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    @scraped_student[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

    @scraped_student
  end

end