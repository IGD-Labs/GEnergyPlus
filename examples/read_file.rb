require_relative "../lib/rbplus"

if ARGV.length != 1
    warn "USAGE: ruby read_file.rb 'NAME_OF_FILE_TO_READ'"
end

idf_file=ARGV[0]

model = EPlusModel.new_from_file(idf_file)  

model.print

exit
p "============"
model.add_from_file(idf_file, ["GlobalGeometryRules"], false )  #EPlusModel.new_from_file(ARGV[0])

model.print

p "============"
model.add_from_file(idf_file, ["Material"], false )  #EPlusModel.new_from_file(ARGV[0])

model.print