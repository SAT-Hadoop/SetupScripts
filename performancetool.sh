apt-get install python-software-properties
apt-add-repository ppa:chris-lea/node.js
apt-get update
apt-get install nodejs
npm install -g bower
npm install -g gulp
git clone https://github.com/Netflix/vector.git
cd vector/
bower install
cd app/
#python -m SimpleHTTPServer 8080
apt-get install pcp pcp-webapi
service pcp start
service pmwebd start


