Author  : CarbonSphere <br>
Email   : carbonsphere@gmail.com<br>

# Privoxy

Default port 8118

Uses AdBlock's blocking list.

# How to use:

	docker run -d -p 8118:8118 --name privoxy carbonsphere/dock-privoxy

Set your browser to http proxy to DOCKER_HOST_IP port 8118

Server may take a while to actually start since it will download the following files before starting services.

	https://easylist-downloads.adblockplus.org/easylist.txt

	https://easylist-downloads.adblockplus.org/easyprivacy.txt

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