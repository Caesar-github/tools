
#!/bin/sh

export DISPLAY=:0.0 
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt
#su linaro -c "python /usr/local/bin/test.py"
su linaro -c "python3.7 /usr/local/bin/test.py"

