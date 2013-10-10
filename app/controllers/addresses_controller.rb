
  
  def find_addressable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end 
  
  
  def update_state_select
      #@states = Region.find(:all,:conditions =>["country_id = ?",params[:country_id]],:order => :region)
      @states = Region.where(:country_id=>params[:country_id]).order(:region) unless params[:country_id].blank?
      render :partial => "states", :locals => { :states => @states}
  end
  
  def get_city(city,region,country)
     @city = City.find(:first,:conditions => ['city = ? and region_id = ?',city,region])
     logger.info @city.inspect
      if @city then
        return @city
      else
        @city = City.new(:city => city,:region_id=>region,:country_id => country)
        if @city.save
          return @city
        end
      end
  end   