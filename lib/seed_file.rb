# Helper class for importing files with records to the database.
class SeedFile
  require 'iconv' 
  def self.import(path)
    new(path).import
  end

  attr_reader :path

  def initialize(path)
    @path = Pathname(path)
  end


  def fix_string(untrusted_string)
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    valid_string = ic.iconv(untrusted_string + ' ')[0..-2]
    return valid_string
  end
  
  # Imports this seed file to its corresponding table in the database.
  def import
    open do |io|
      case format
      when :yml, :yaml
        import_yaml(io)
      when :json
        import_json(io)
      when :csv
        import_csv(io)
      end
    end

    return true
  end

  # Returns the format of this seed file as a symbol (e.g. :yaml or :json).
  def format
    (gzip?? path.basename(path.extname) : path).extname[1..-1].downcase.to_sym
  end

  # Returns true if the seed file is gzipped.
  def gzip?
    path.extname == '.gz'
  end

  private

  def open(&block)
    if gzip?
      IO.popen("gunzip -c #{path.realpath}", &block)
    else
      path.open(&block)
    end
  end

  # Gets the ActiveRecord::Base subclass for this seed file.
  def klass
    @klass ||= path. # #<Pathname:db/seeds/countries.yml>
               basename. # #<Pathname:countries.yml>
               to_s. # "countries.yml"
               split('.'). # ["countries", "yml"]
               first. # "countries"
               classify. # "Countries"
               singularize. # "Country"
               constantize # Country
  end

  # Imports a YAML array of records, i.e.:
  #
  # ---
  # - name: Jeff
  # born_on: 1983-10-19
  # - name: Brad
  # born_on: 1972-02-06
  def import_yaml(io)
    require 'yaml' unless defined?(YAML)
    YAML.load(io).each {|data| import_record data }
  end

  # Imports JSON structures one line at a time, i.e.:
  #
  # {"name":"Jeff","born_on":"1983-10-19"}
  # {"name":"Brad","born_on":"1972-02-06"}
  def import_json(io)
    require 'active_support/json' unless defined?(ActiveSupport::JSON)
    while line = io.gets
      import_record ActiveSupport::JSON.decode(line.chomp)
    end
  end
  
  
  def import_csv(io)
    #require 'fastercsv'
    require 'csv'

    puts "importing_csv"
    
    puts "deleting existing records"
    #Delete any existing records in the database and reseed
    delete_records    
    
      if CSV.const_defined? :Reader
        puts 'faster csv'
        csv = FasterCSV
        temp = csv.open(io.path, 'r',{:headers=>true,:row_sep => :auto,:encoding => 'N'})

         #csv.each do |row|
  
      
        temp.each do |row|
          puts row
          row = row.to_hash.with_indifferent_access
          #puts row
          import_record row
          #Moulding.create!(row.to_hash.symbolize_keys)
        end      
      else
        puts 'csv'
        csv = CSV
        csv_text = File.read(io).to_s
        csv_text = fix_string(csv_text)
        temp = CSV.parse(csv_text, :headers => true)
      
        temp.each do |row|
  
      
      
        puts row
        row = row.to_hash.with_indifferent_access
        #puts row
        import_record row
        #Moulding.create!(row.to_hash.symbolize_keys)
      end    
    
    end
    

    
    
    
  end
  def delete_records
    
    klass.delete_all
  end
  def import_record(attributes)
    klass.new.tap do |record|
      # bypass attr_accessible / attr_protected
      
      attributes.each do |key, value|
        #puts value
        record[key.tableize.singularize] = value
      end
      # bypass validations
      record.save :validate => false
    end
  end
end