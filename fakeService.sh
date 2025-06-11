#/bin/bash

# Auto healing: Restart fake service if not running
echo "Checking fake service status..."

if ! pgrep -f fakeService.sh > /dev/null
then
echo "Fake scenarios is not running. Restarting it..."
/mnt/c/Users/Saksham/fakeService.sh & #actual path
else
echo "Fake servic is running"
fi
while true
do
echo "Fake service is running..."
sleep 10
done
