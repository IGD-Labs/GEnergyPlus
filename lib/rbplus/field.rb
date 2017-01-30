module EPlusModel  
    class EnergyPlusObjectField
        attr_accessor :name, :note, :required, :type, :value_type, :default, :keys, :value
        attr_accessor :minimum, :maximum, :retaincase, :units, :object_list, :reference, :ip_units
        attr_accessor :units_based_on_field, :autocalculatable, :autosizable, :external_list, :begin_extensible

        def initialize(name)
            @name = name
            @note = ""
            @required = false
            @type = false
            @value_type = false
            @default = false
            @keys = []
            @value = nil
            @minimum = false
            @maximum = false
            @retaincase = false
            @units = false
            @object_list = false
            @reference = false
            @ip_units = false
            @units_based_on_field = false
            @autocalculatable = false
            @autosizable = false
            @external_list = false
            @begin_extensible = false
        end


        def print(file,final)
            comma = ","
            comma = ";" if final
            if @value then
                file.puts "     #{@value}#{comma}     !-- #{@name}"
            else
                if @default then                    
                    file.puts "     #{@default}#{comma}     !-- #{@name} (default value)"                
                else
                    if @required then
                        raise "Fatal: not input nor default value at '#{@name}"
                    else                        
                        file.puts "     #{comma}     !-- #{@name} (value not required)"
                    end
                end
            end           
        end


        def help (final)            
            comma = ","
            comma = ";" if final     
            default = "Default value: #{@default ?  @default : "FALSE" }"
            required = @required ? "REQUIRED" : "NOT REQUIRED" 
            choices = (@type.is_a? String and @type.downcase == "choice") ? "| Choices: [#{@keys.join(",")}]" : ""

            puts "     #{comma}     !-- #{@name}  ( Type: #{@type} | #{default} | #{required} #{choices} )"                                       
        end

        def numeric?
            @value_type[0].downcase == "n"
        end

        def set_value(value)
            if @type.is_a? String and @type.downcase == "choice" then
                raise "Incorrect key in 'choice' field of... '#{value}' was inputed while the options are [#{@keys.join(",")}] " if not @keys.map{|x| x.downcase}.include? value.downcase
            end
            self.value = value
        end

    end
end