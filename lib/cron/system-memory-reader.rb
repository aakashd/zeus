free_memory = `free -m`.split("\n").find(){ |l| l.include? "Mem" }.split("\s")[3]

p "free_memory => " + free_memory
