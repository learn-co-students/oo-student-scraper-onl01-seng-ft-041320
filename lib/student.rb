require "pry"
class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
    @name = student_hash[:name]
    @location = student_hash[:location]
    @twitter = student_hash[:twitter] 
    # binding.pry
    @linkedin = student_hash[:linkedin] 
    @github = student_hash[:github] 
    @blog = student_hash[:blog]
    @profile_quote = student_hash[:profile_quote]
    @bio = student_hash[:bio]
    @profile_url = student_hash[:profile_url]

    @@all << self
    end

  def self.create_from_collection(students_array)
      students_array.each do|student|
        Student.new(student)
      end
  end
  

  def add_student_attributes(attributes_hash)
     attributes_hash.each do |key, value|
        # if additional_atrib_array[1].include?(key)
          case key
          when :twitter
            self.twitter = attributes_hash[key]
          when :linkedin
            self.linkedin = attributes_hash[key]
          when :github
            self.github = attributes_hash[key]
          when :blog
            self.blog = attributes_hash[key]
          when :profile_quote
            self.profile_quote = attributes_hash[key]
          when :bio
            self.bio = attributes_hash[key]
          when :profile_url 
            self.profile_url = attributes_hash[key]
          else
          end
          # binding.pryq

    end
  end

  def self.all
    @@all
  end
end

  
