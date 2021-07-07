require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []

    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.student-card").each do |student|
      students_details = {}
        students_details[:name] = student.css("h4.student-name").text
        students_details[:location] = student.css("p.student-location").text
        students_details[:profile_url] = student.css("a").attribute("href").value
        students << students_details
    end
    students
  end

#access_all_students: doc.css("div.student-card")
#student_name: doc.css("div.student-card a div.card-text-container h4.student-name").text
#student_location: doc.css("div#ryan-johnson-card a div.card-text-container p.student-location").text
#student_profile_url: doc.css("div#ryan-johnson-card a").attribute("href").value

  def self.scrape_profile_page(profile_url)
    student_profile = {}
    html = open(profile_url)
    profile = Nokogiri::HTML(html)

    # Social Links

    profile.css("div.main-wrapper.profile .social-icon-container a").each do |social|
      if social.attribute("href").value.include?("twitter")
        student_profile[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        student_profile[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        student_profile[:github] = social.attribute("href").value
      else
        student_profile[:blog] = social.attribute("href").value
      end
    end

    student_profile[:profile_quote] = profile.css("div.main-wrapper.profile .vitals-text-container .profile-quote").text
    student_profile[:bio] = profile.css("div.main-wrapper.profile .description-holder p").text

    student_profile
  end
end

#access_social_medias: doc.css("div.social-icon-container")
#access_each_social_media: doc.css("div.social-icon-container a").attribute("href").value

