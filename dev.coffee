
bash = require "calabash"

bash.do "watch and compile",
  "pkill -f doodle"
  "coffee -o client -cwm src/"
  "doodle src/ view/ server/ log:yes"