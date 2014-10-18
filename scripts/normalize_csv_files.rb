require 'csv'

DATA_DIR = File.expand_path("../../data/src", __FILE__)

Dir.glob(File.join(DATA_DIR,"*.txt")).each do |txt_file|
 cmd = "in2csv -f csv -d \"|\" " + txt_file + " > " + txt_file.gsub('src','csv').gsub(".txt",".csv")
 puts cmd
 system cmd
end
