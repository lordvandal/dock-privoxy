Author: [CarbonSphere](https://github.com/carbonsphere)<br>
Email: carbonsphere@gmail.com<br>
Original repository: https://github.com/carbonsphere/dock-privoxy

Improvements: [lordvandal](https://github.com/lordvandal)<br>
Repository: https://github.com/lordvandal/dock-privoxy

# Privoxy

Default port 8118

Uses AdBlock's blocking list.

# How to use:

	docker run -d -p 8118:8118 --name privoxy carbonsphere/dock-privoxy

Set your browser to http proxy to DOCKER_HOST_IP port 8118

Server may take a while to actually start since it will download the following files before starting services.

	https://easylist-downloads.adblockplus.org/easylist.txt

	https://easylist-downloads.adblockplus.org/easyprivacy.txt

	https://easylist-downloads.adblockplus.org/easylistgermany.txt
	
	https://easylist-downloads.adblockplus.org/easylistchina.txt
	
	https://easylist-downloads.adblockplus.org/antiadblockfilters.txt

	https://easylist-downloads.adblockplus.org/fanboy-annoyance.txt

# You can check privoxy service by using the following docker command

	docker logs privoxy

	wait till you see "Info: Program name: /usr/sbin/privoxy"

# Check Privoxy Status

  - After Proxy setting is done. Navigate to 

  	http://config.privoxy.org

  - Status page

  	http://config.privoxy.org/show-status

# Check privoxy filtering or not

  - This page should be Blocked if privoxy is working!

  	http://www.advertising.com

# Privoxy Chaining Tor


  - Added ability to chain proxy 

  	Add the following environment variable will allow scripts to automatically add forwarding directives to configuration

  	FORWARD_DNS=tor
  	FORWARD_PORT=5566

  - Checkout "carbonsphere/rotating-proxy". It is a cached proxy + Tor proxy.

  	docker run -d --name tor -p 5566:5566 carbonsphere/rotating-proxy 

 Note: rotating proxy may require sometime to initialize. Check rotating proxy first before starting privoxy.

  	docker run -d --name privoxy -p 8118:8118 --link tor:tor -e FORWARD_DNS=tor -e FORWARD_PORT=5566 carbonsphere/dock-privoxy

This setup will allow you to use the following connection path.

  Client (Web Browser) ---->  Privoxy (none cached) ----> HA Proxy ----> Polipo n (cached) ----> Tor proxy n
