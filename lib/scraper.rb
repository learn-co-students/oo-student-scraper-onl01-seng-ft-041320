require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    html = open(index_url)

    doc = Nokogiri::HTML(html)
    students = []

    doc.css("div.student-card").each do |student|
      student_details = {}
      student_details[:name] = student.css("h4.student-name").text
      student_details[:location] = student.css("p.student-location").text
      student_details[:profile_url] = student.css("a").attribute("href").value
      students << student_details
    end

    students

  end

  def self.scrape_profile_page(profile_url)

    html = open(profile_url)

    doc = Nokogiri::HTML(html)

    scraped_details = {}

    doc.css(".social-icon-container a").each do |social|
      if social.attribute("href").value.include?("twitter")
        scraped_details[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        scraped_details[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        scraped_details[:github] = social.attribute("href").value
      else
        scraped_details[:blog] = social.attribute("href").value
      end
    end

    scraped_details[:profile_quote] = doc.css("div.profile-quote").text
    scraped_details[:bio] = doc.css("div.description-holder p").text

    scraped_details

  end


end
