# require Rails.root.join('lib/load_projects')
# -or-
# load Rails.root.join('lib/load_projects.rb')
require "json"

module LoadProjects
  def self.from_json(file: "/Users/edward/Desktop/emergencyINDEX/index1projects.json")
    file = File.read file
    projects = []
    JSON.parse(file).each_with_index do |project, idx|
      begin
        h = {}
        h = info_from(project["info"])
        h["photo_credit"] = project["photo_credit"]
        # h["image"] = project["image"]
        if h["title"] != project["description"][0]
          if h["title"] == project["description"][0] + project["description"][1]
            project["description"][0] = project["description"][0] + project["description"].delete(project["description"][1]) 
          end
        end
        project["description"].reject!(&:blank?)
        project["description"].each{|d| d.squish! }
        raise "mismatch title! idx: #{idx}, #{h["title"]} != #{project["description"][0]},\n h: #{h}, \nproject: #{project}" if h["title"] != project["description"][0]
        raise "mismatch name! idx: #{idx}, #{h["name"]} != #{project["description"][1]},\n h: #{h}, \nproject: #{project}" if h["name"] != project["description"][1]
        h["description"] = project["description"][2..999].join("\n\n")
        projects << h
      rescue Exception => e
        raise "error! e: #{e}\nproject: #{project}"
      end
    end
    projects
  end

  def self.info_from(i)
    i.reject!(&:empty?)

    begin
      Time.strptime(i[1].gsub('first performed','').gsub('on','').squish, '%B %e, %Y').strftime('%Y/%m/%d')
    rescue
      #i guess this is a long title name
      i[0] = i[0] + i[1]
      i.delete(i[1])
    end

    begin
      h = { 
        "title" => i[0].squish,
        "first_performed" => Time.strptime(i[1].gsub('first performed','').gsub('on','').squish, '%B %e, %Y').strftime('%Y/%m/%d'),
        "venue" =>  i[2].split(',').length > 2 ?  i[2].split(',')[0..-3].join(',').squish : i[2].squish,
        "city" =>  i[2].split(',').length > 1 ? i[2].split(',')[i[2].split(',').length - 2].squish : nil,
        "country" =>  i[2].split(',').length > 1 ? i[2].split(',').last.squish : nil,
        "times_performed" =>  intfstr(i[3].gsub('performed ','').gsub('in 2011','').gsub('times','').squish),
        "name" =>  i[4].squish,
      }
      if(i.length > 8)
        h.merge!({ 
          "needs_review" =>  true
        })
      else
        h.merge!({
          "home" =>  i[5].squish,
          "links" =>  (i[7] and i[7].include?('.') and !i[7].include?('.')) ? i[7].squish : (i[6] and i[6].include?('.') ? i[6].squish : ''),
          "published_contact" => (i[6] and i[6].include?('@') ? i[6].squish : (i[7] and i[7].include?('@') ? i[7].squish : '')),
        })
      end
      h.merge({ "original_scrape" =>  {"info" =>  i}})
    rescue Exception => e
      raise "parse error! e: #{e}\ni: #{i}"
    end
  end

  def self.description_from(description_json)

  end

  private
  def self.intfstr(str)
    h = {
      'once'  =>  1,
      'twice' =>  2,
      'three' =>  3,
      'four'  =>  4,
      'five'  =>  5,
      'six'   =>  6,
      'seven' =>  7,
      'eight' =>  8,
      'nine'  =>  9,
      'ten'   =>  10
    }
    h[str].nil? ? str.to_i : h[str]
  end
end

# {
#   "image" =>  "The_Island.jpg",
#   "info" =>  [
#     "THE ISLAND",
#     "first performed on April 11, 2011",
#     "Dixon Place, New York, NY",
#     "performed once in 2011",
#     "FLY BY NIGHT THEATER",
#     "Matt Reeck",
#     "Brooklyn, NY",
#     "matt.reeck@gmail.com"
#   ],
#   "photo_credit" =>  "Rob Lariviere",
#   "description" =>  [
#     "THE ISLAND",
#     "FLY BY NIGHT THEATER",
#     "“The Island” addresses the problem of identity politics, or the stereotypes we assume from the identity-related information that appearance provides. This happens within the play and between the audience and the actors. Of the play’s three characters, two have unstable identities. The Woman finds the Boatman standing next to a boat, but he isn’t really a boatman (the boat is his brother’s). In addition, the Guide is really a religion student, willing to serve as a guide for uncertain, perhaps nefarious, reasons. The play tempts the audience to misread identity-related aspects of its staging. The play never names its setting, and the characters themselves aren’t named. It takes place in a zero-space, or minimalist, existential one, in which clues (cues) for nation, race and religion are few and, when present, send mixed messages. Casting choices help confuse the sense of place and identity. The Boatman and the Guide share a language that the Woman doesn’t, but they are hostile to each other, marking them as relatively foreign as well. Then, the persons playing these two roles must clearly not be from the same “native” country: they must be different races. This frustrates the audience’s ability to fill in absent identity-related information by extrapolating from “real-world” details read off the actors’ bodies. Instead of coming to a firm conclusion, the play hopes to invalidate whatever stopgap answers the audience arrived at during its course. ",
#     "The situation of this play is roughly postcolonial, and as such echoes Edouard Glissant’s poetics of relation. Glissant argues that cultures are largely opaque to each other, and when persons of different cultures inhabit a shared space they should approach each other slowly and with the constant expectation of strangeness. The world may be uniformly visible, but its visibility can be the immediate source of error when we facilely over-read, or over-interpret, its signs. “The Island” riffs on this sort of projection. The Woman has uncompromising but naïve expectations about finding a particular wall on a particular island that her guidebook asserts exists but about which the natives are ambivalent. Yet they are eager to please, and they don’t seem to have anything better to do. They go along with the Woman, trying their best to satisfy her, reshaping an ambiguous reality to meet her demands for factuality and clarity."
#   ]
# }
