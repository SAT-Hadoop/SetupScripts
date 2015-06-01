<h1> Intro </h1>

<p> sat-hadoop is a distributed job scheduler for submitting jobs to a multi purpose cluster. It could be hadoop jobs, mpi. The application is hosted on Eucalyptus which is a private cloud platform </p> 
<p> The application has four components </p>

<ol> 
Scheduler is the UI of the application built using JSP, Servlets authenticated using central authentication service of IIT and https
</ol>

<ol>
Distributed Message Queue , is all the user jobs are contained. Amazon SQS has been used. Exploring multiple open source MQ's that are out there to have an in house mq.
</ol>

<ol>
Backend Worker , looks into the mq and processes the jobs one after another
</ol>

<ol>
Autoscaling groups, The Scheduler, mq and the backend workers all within Autoscaling groups and can scale up/down depending on demand.
</ol>

<h1> Below are the instructions used to setup the indivijual components of sat-hadoop </h1>


<h1>Instructions to setup the Scheduler</h1>
<ol>
import your AWS credentials to AWSACCESSKEY and AWSSECRETKEY using the export command
</ol>
<ol>
Clone the scheduler-setup.sh and run it
</ol>
Open http://ipaddress/app/index in the browser to get started
</ol>



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
~                 
