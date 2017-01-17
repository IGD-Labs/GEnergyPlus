module EPlusModel

  class Model
    
    def initialize(version)
      @idd_dir = File.join(File.dirname(File.expand_path(__FILE__)), 'idd_files')    
      @version = version      
      raise "Fatal: Wrong EnergyPlus version... IDD file not found or not supported" if not File.file? "#{@idd_dir}/#{@version}.idd"
      @idd = IDD.new("#{@idd_dir}/#{@version}.idd")
      @objects = Hash.new

      self.add("version",{"version identifier" => version})
    end

    def add(object_name, inputs)
      object_name.downcase!

      object = get_definition(object_name) #this raises an error if the object does not exist      
      object.check_input(inputs)  #this raises an error if any
      object = object.create(inputs)      

      if object.unique then
        if @objects.key? object_name then
          raise "Trying to replace unique object '#{object_name}'"
        else
          self[object_name] = object     
        end
      else
        if @objects.key? object_name then                      
          self[object_name] << object
        else            
          self[object_name] = [object]     
        end
      end
    end

    def print 
      @objects.each{|key,value|    
        if value.is_a? Array then
          value.each{|i| 
            i.print
            puts ""
          }                  
        else    
          value.print
        end
        puts ""        
      }
    end

    def help(object_name)
      object = @idd[object_name.downcase] #this raises an error if the object does not exist       
      object.help  
    end

    def describe(object_name) 
      object = @idd[object_name.downcase] #this raises an error if the object does not exist       
      puts "!- #{object_name.downcase}"
      puts "!- #{object.memo}"
      puts ""
    end

    def get_definition(object_name)
        @idd[object_name.downcase] #this raises an error if the object does not exist 
    end
    
    def find(query)
      @idd.keys.select{|x| x.downcase.include? query.downcase}      
    end
    
    def [](object_name)
        @objects[object_name.downcase]
    end

    def []=(object_name,object)
        @objects[object_name.downcase] = object
    end

    def get_object_by_id(id)
        @objects.each{|key,object|
            if object.is_a? Array then
                object = object.get_object_by_id(id)
                return object if object
            else
                return value if object.id and object.id.downcase == id.downcase
            end
        }
        return false
    end

  end #end of class

end