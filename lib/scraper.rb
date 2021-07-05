require 'open-uri'
require 'pry'

# I wanted to make a method that gets the name of the social media
# from the link. Ex) https://twitter.com/somepersonidk => twitter
# I figured as I was iterating through all of the students social media I could make a key using this
# and of course the value would be the link itself. That way if a student didn't have a certain social media
# I didn't have a key with no value assigned to it.
def social_media_name(url)
  if url.include?("www")
    url_name = url.gsub("https://www.","")
    url_name = url_name.split(".com").unshift
    url_name[0]
  elsif url.include?("https")
    url_name = url.gsub("https://","")
    url_name = url_name.split(".com").unshift
    url_name[0]
  else
    url_name = url.gsub("http://","")
    url_name = url_name.split(".com").unshift
    url_name[0]
  end
end
#binding.pry I was checking if this method actually worked. It works for this lab at least lol

class Scraper
   #student info:  doc.css("div.student-card") #This is what I need to iterate over to get the info for each student
  #student names: (the above ^^^^ saved as a variable).css("h4.student-name")
  #student locations: student_variable.css("p.student-location")
  #profile link: student_variable.css("a").attribute("href").value

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    #test wants to return an array of hashes
    students_array = []
    doc.css("div.student-card").each do |student|
      #create the hash to shovel into the array
      student_info = {}
      student_name = student.css("h4.student-name").text
      student_location = student.css("p.student-location").text
      profile_link = student.css("a").attribute("href").value
      student_info[:name] = student_name
      student_info[:location] = student_location
      student_info[:profile_url] = profile_link
      students_array << student_info
    end
    #binding.pry I was checking to make sure each piece was being added to the array correctly
    students_array
  end
  
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    #all of the social media links are contained here
    social_media = doc.css("div.social-icon-container a")
    # the quote
    quote = doc.css("div.profile-quote").text
    # the bio
    bio = doc.css("div.description-holder p").text
    #binding.pry I was checking to make sure each thing was what I thought it was

    #This time it wants us to return a hash
    student_info = {}
    #iterating through all of the social media links
    social_media.each do |link|
      #using the method I made to give me the social media name
        media_name = social_media_name(link.attribute("href").value)
        # if it is the students personal blog the key in the hash can't be the site name so
        # this part is checking to make sure it's not the blog
        if media_name == "twitter" || media_name == "github" || media_name == "linkedin"
          student_info[media_name.to_sym] = link.attribute("href").value
        else
          student_info[:blog] = link.attribute("href").value
        end
    end
    # Now that the social media is all part of the hash, we need to add the quote and bio
    student_info[:profile_quote] = quote
    student_info[:bio] = bio
    student_info
  end

end

