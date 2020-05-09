require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_cards = doc.css(".student-card")
    students = []
    student_cards.each do |student|
      student_name = student.css(".student-name").text
      student_location = student.css(".student-location").text
      student_profile_url = student.css("a").attr("href").value
      student_hash = {name: student_name, location: student_location, profile_url: student_profile_url}
      students << student_hash
    end
    students
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    doc = Nokogiri::HTML(open(profile_url))
    social_profiles = doc.css(".social-icon-container a").collect {|link| link.attribute("href").value}
    social_profiles.each do |profile|
      if profile.include?("twitter")
        student[:twitter] = profile
      elsif profile.include?("linkedin")
        student[:linkedin] = profile
      elsif profile.include?("github")
        student[:github] = profile
      elsif profile.include?(".com")
        student[:blog] = profile
      end
    end
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css("div.description-holder p").text
    student
  end

end

