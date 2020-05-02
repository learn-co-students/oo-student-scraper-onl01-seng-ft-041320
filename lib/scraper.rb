require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  # responsible for scraping the index page that lists all of the students
  def self.scrape_index_page(index_url)
    cards = Nokogiri::HTML(open(index_url)).css(".student-card")

    profiles = []

    cards.each do |card|
      profiles << {
                    name:        card.css(".student-name").text,
                    location:    card.css(".student-location").text,
                    profile_url: card.css("a").attribute("href").value
                  }
    end

    profiles
  end

  # responsible for scraping an individual student's profile page to get further information about that student
  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url)).css("[class='main-wrapper profile']")

    social_media_links = []

    social_media_container = profile.css(".social-icon-container a")
    social_media_container.each do |link|
      social_media_links << link.attributes.first.last.value
    end

    profile_info = {
      profile_quote: profile.css(".profile-quote").text,
      bio: profile.css(".description-holder p").text
    }

    # handles adding social media links to profile_info hash
    social_media_links.each do |link|
      if (link.include?("twitter"))
        profile_info[:twitter] = link
      elsif (link.include?("github"))
        profile_info[:github] = link
      elsif (link.include?("linkedin"))
        profile_info[:linkedin] = link
      else
        profile_info[:blog] = link
      end
    end

    #binding.pry
    profile_info
  end

end

