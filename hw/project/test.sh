./start_servers.sh

sleep 2
{
	sleep 1
	echo IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
} | telnet localhost 12000

pkill -f 'python server.py Holiday'

{
	sleep 1
	echo WHATSAT kiwi.cs.ucla.edu 10 5
} | telnet localhost 12001

pkill -f 'python server.py Hamilton'
pkill -f 'python server.py Alford'
pkill -f 'python server.py Ball'
pkill -f 'python server.py Welsh'