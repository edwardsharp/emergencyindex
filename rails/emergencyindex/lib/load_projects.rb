# require Rails.root.join('lib/load_projects')
# -or-
# load Rails.root.join('lib/load_projects.rb')
require "json"
require 'nokogiri'

module LoadProjects

  #this one will take a bit... it would be faster to create a hash of page numberz => [..tags]
  def self.and_create_term_tags(file: "/Users/edward/Desktop/emergencyINDEX/index1terms.json")

    f = File.read file
    
    aliases = []

    JSON.parse(f).each do |term|
      _name = term["name"]
      _subTerm = nil

      if term["alias"]
        aliases << term
        next
      end 
      if term["pages"]
        term["pages"].gsub!(/\(.*?\)/) do |fixNestedCommaBeforeSplit|
          fixNestedCommaBeforeSplit.gsub!(',', '|')
        end
        term["pages"].split(/,|;/).each do |t|
          _page = t.scan(/\d+/)[0]
          project = Project.where('pages LIKE ?', "%#{_page.rjust(3, '0')}%").first
          _tag = nil
          if t.scan /[a-zA-Z]/
            _subTerm = t.gsub(_page,'').squish.gsub('|',',')
            _tag = "#{_name} #{_subTerm}"
          else 
            if _subTerm
              _tag = "#{_name} #{_subTerm}"
            else
              _tag = "#{_name}"
            end
          end
          project.tag_list.add(_tag)
          project.save(validate: false)
          if term["see_also"]
            _t = Project.tagged_with(_tag).first.tags.first
            if _t.see_also.nil?
              _t.see_also = term["see_also"]
              _t.save
            else
              unless _t.see_also.include?(term["see_also"])
                _t.see_also = "#{_t.see_also}, #{term["see_also"]}" 
                _t.save
              end
            end
          end
        end #term["pages"].split
      end #if term["pages"]
    end #terms.each
    aliases
  end

  def self.and_create_terms(file: "/Users/edward/Desktop/emergencyINDEX/index1terms.html")

    #.split /,|;/
    page = Nokogiri::HTML(open(file))

    terms = []
    page.css('p').each do |_p|
      begin
        _term = {}
        _term['name'] = _p.css('*[class*="INDEX-term"]').first.text.squish
        
        _see_also = false
        _alias = false
        _p.children[1..999].each do |child|
          next if child.text.blank?

          if child.text.match /see a/
            _see_also = true
          elsif _see_also
            _term['see_also'] = child.text.gsub('lso ','').squish
            _see_also = false
          elsif child.text.match /see /
            _alias = true
          elsif _alias
            _term['alias'] = child.text.squish
            _alias = false
          elsif child.text.match /\d+/
            _term['pages'] = child.text.squish
          end
        end #_p.children .each
        terms << _term

      rescue 
        raise "PARSE ERROR _p:\n#{_p}\n"
      end
    end

    File.open("/Users/edward/Desktop/emergencyINDEX/index1terms.json","w"){|f| f.write(terms.to_json)}

  end

  def self.show_duplicates
    Project.unscope(:order).select(:title,:name).group(:title,:name).having("count(*) > 1").size
  end

  def self.and_create_pages(dir: "/Users/edward/Desktop/emergencyINDEX/eps/txt/*.txt")
    projects_updated = 0
    Dir[dir].each do |txt|
      f = IO.readlines(txt)
      page = f[-1].squish.split('PAGE ')[1].split(' ')[0] rescue next
      next if page.to_i.even?
      title_be_like = f[0].squish.gsub(/[^a-z0-9\s]/i, '%')
      projects = Project.where('title ILIKE ?', "%#{title_be_like}%")
      if projects.count > 1
        projects = Project.where('title ILIKE ? AND name ILIKE ?', "%#{title_be_like}%", "%#{f[1].squish}%")
      end
      raise "multiple projecs found!" if projects.count > 1
      project = projects.first
      project.pages = "#{(page.to_i - 1).to_s.rjust(3, '0')}-#{page.rjust(3, '0')}"
      project.save(validate: false)
      projects_updated += 1
    end
    projects_updated
  end

  def self.and_create_images(file: "/Users/edward/Desktop/emergencyINDEX/index1projects.json")
    file = File.read file
    problemz = []
    JSON.parse(file).each_with_index do |project, idx|
      #/Users/edward/Desktop/emergencyINDEX/idx1html2/INDEX1-web-resources/image
      
      begin
        f = File.new("/Users/edward/Desktop/emergencyINDEX/idx1html2/INDEX1-web-resources/image/#{project["image"].gsub('.png','.jpg')}","r")
      rescue
        problemz << ['no file found!', idx, project["image"], project["info"][0]]
        next
      end

      proj = Project.where("title ILIKE ?", "%#{project["info"][0].squish.upcase}%").first

      problemz << ['no project found!',idx, project["image"], project["info"][0]] if proj.nil?
      next if proj.nil?
      proj.attachment = f
      proj.save!(validate: false)

      # img_probz.each do |img_prob|
      #   title = img_prob[3].nil? ? img_prob[2] : img_prob[3]
      #   i = img_prob[3].nil? ? img_prob[1] : img_prob[2]
      #   proj = Project.where("title ILIKE ?", "%#{title.gsub(',','').squish.upcase}%").first
      #   proj.attachment = File.new("/Users/edward/Desktop/emergencyINDEX/idx1html2/INDEX1-web-resources/image/#{project["image"].gsub('..','.').gsub('.png','.jpg')}","r")
      #   proj.save!(validate: false)
      # end
    end
    problemz
  end

  def self.and_create_projects(file: "/Users/edward/Desktop/emergencyINDEX/index1projects_PARSED_and_fixed.json")
    file = File.read file
    problemz = []
    JSON.parse(file).each do |project|
      # begin
      #   project = Project.create! project
      # rescue
      #   # p "rescue! project: #{project}"
      #   problemz << [project, 'CANT CREATE!']
      #   next
      # end
      project = Project.new project.merge({
        volume: Volume.where(year: 2011).first, 
        user: User.first, 
        already_submitted: false, 
        published: true
      })

      project.save!(validate: false)
      # begin
      #   project.save!
      # rescue 
      #   # p "rescue! project: #{project.errors}"
      #   problemz << [project, project.errors]
      # end
    end
    # p "\n\n\nPROBLEMZ: #{problemz}\n\n\n"
    problemz
  end

  def self.and_export_json(file: "/Users/edward/Desktop/emergencyINDEX/index1projects_PARSED.json")
    File.open(file,"w") do |f|
      f.write(LoadProjects.from_json.to_json)
    end
  end

  def self.from_json(file: "/Users/edward/Desktop/emergencyINDEX/index1projects.json")
    file = File.read file
    projects = []
    JSON.parse(file).each_with_index do |project, idx|
      begin
        h = {}
        h = info_from(project["info"])
        h["photo_credit"] = project["photo_credit"].squish
        # h["image"] = project["image"]
        project["description"][0].upcase!
        if h["title"].upcase != project["description"][0].upcase
          if h["title"] == project["description"][0].upcase + project["description"][1].upcase
            project["description"][0] = project["description"][0].upcase + project["description"].delete(project["description"][1]).upcase
            project["description"][0].upcase
          end
        end
        project["description"].reject!(&:blank?)
        project["description"][0].squish!
        project["description"][1].squish!
        # project["description"].each{|d| d.squish! }
        raise "mismatch title! idx: #{idx}, #{h["title"]} != #{project["description"][0]},\n h: #{h}, \nproject: #{project}" if h["title"] != project["description"][0]
        #p "mismatch name! idx: #{idx}, #{h["name"]} != #{project["description"][1]},\n h: #{h}, \nproject: #{project}" if h["name"] != project["description"][1]
        h["contact_name"] = project["description"][1].upcase
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

    #de-ordinalize day numberz e.g. 12th -> 12
    deo = Regexp.union(
      /(\d+)st/,
      /(\d+)nd/,
      /(\d+)rd/,
      /(\d+)th/
    )
    begin
      Time.strptime(i[1].gsub('first','').gsub('performed','').gsub('on','').gsub(deo){|r| Regexp.last_match[1..4].find{|a|!a.nil?} }.squish, '%B %e, %Y').strftime('%Y/%m/%d')
    rescue
      #i guess this is a long title name
      i[0] = i[0] + i[1]
      i.delete(i[1])
    end

    begin
      h = { 
        "title" => i[0].squish.upcase,
        "first_performed" => Time.strptime(i[1].gsub('first','').gsub('performed','').gsub('on','').gsub(deo){|r| Regexp.last_match[1..4].find{|a|!a.nil?} }.squish, '%B %e, %Y').strftime('%Y/%m/%d'),
        "venue" =>  i[2].split(',').length > 2 ?  i[2].split(',')[0..-3].join(',').squish : i[2].squish,
        "city" =>  i[2].split(',').length > 1 ? i[2].split(',')[i[2].split(',').length - 2].squish : nil,
        "country" =>  i[2].split(',').length > 1 ? i[2].split(',').last.squish : nil,
        "times_performed" =>  intfstr(i[3].gsub('performed','').gsub('times','').gsub('in 2011','').squish),
        "name" =>  i[4].squish.upcase,
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
      p "first_performed: #{i[1]}"
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
