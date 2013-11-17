
bash = require "calabash"

bash.do "watch and compile",
  "pkill -f doodle"
  "coffee -o client -cwm src/"
  "doodle client/ view/ server/ index.html log:yes"