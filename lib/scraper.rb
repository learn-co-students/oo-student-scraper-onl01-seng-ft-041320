require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_array = []
    uri = open(index_url)
    doc = Nokogiri::HTML(uri)
    students = doc.css(".student-card")
    students.each do |student|
      hash = {}
      hash[:name] = student.css(".student-name").text
      hash[:location] = student.css(".student-location").text
      hash[:profile_url] = student.css("a[href]").first['href']
      student_array << hash
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    uri = open(profile_url)
    doc = Nokogiri::HTML(uri)
    student_hash = {}
    social_media = doc.css(".social-icon-container").css("a[href]")
    social_media.each do |social|
      student_hash[:twitter] = social['href'] if social['href'].include?("twitter")
      student_hash[:linkedin] = social['href'] if social['href'].include?("linkedin")
      student_hash[:github] = social['href'] if social['href'].include?("git")
      student_hash[:blog] = social['href'] unless social['href'].include?("linkedin")||social['href'].include?("git")||social['href'].include?("twitter")
    end
    student_hash[:profile_quote] = doc.css(".profile-quote").text.strip
    student_hash[:bio] = doc.css(".bio-content .description-holder").text.strip
    student_hash
  end

end

# social media container: doc.css(".social-icon-container")
  # twitter: .css("a[href]")[0]['href']
  # linkedin: .css("a[href]")[1]['href']
  # github: .css("a[href]")[2]['href']
  # blog: .css("a[href]")[3]['href']
# profile quote: doc.css(".profile-quote").text
# bio: doc.css(".bio-content .description-holder").text
