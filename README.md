<h1> Instructions to using these scripts to setup a hadoop cluster </h1>
<h4> You will need a ubuntu system to be able to run the scripts </h4>
<hr>
<ol>
Run setup-hadoop.sh on the master
</ol>
<ol>
Launch all the necessary slaves and gather their ip addresses. Use the same pem file as the master
</ol>
<ol>
Add them to slaves list in /hadoop-2.6.1/etc/hadoop/slaves
</ol>
<ol>
have the pem file, setup-hadoop.sh,syncslaves.sh in the same directory
</ol>
<ol>
Run the syncslaves.sh and you are good to go
</ol>
<ol>
On the master, do a start-all.sh
</ol>
