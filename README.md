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

<h4> Below are the instructions used to setup the indivijual components of sat-hadoop on UBUNTU</h4>


<h4>Instructions to setup the Scheduler</h4>
<ol>
Launch an ec2 instance with ubuntu-xx.xx as the OS.
</ol>
<ol>
Clone the current repo and run scheduler-setup.sh
</ol>
<ol>
Open http://ipaddress/app/index in the browser to get started
</ol>



<h4> Instructions to setup the backend worker/workers </h4>
<hr>
<ol>
Launch as many ec2 instances as you need ec2 with ubuntu-xx.xx as the OS attaching the setup-hadoop.sh at the time of instance creation.
</ol>
<ol>
attach an EBS to mount the volume on to the directory /vol-01. The script disksetup.sh does the same. Attach disksetup.sh at the time of instance launch
</ol>
<ol>
Login to the instance, clone the current repository
</ol>
<ol>
clone the repo's https://github.com/SAT-Hadoop/BackendWorker and https://github.com/SAT-Hadoop/sat-hadoop-api. Do a mvn install on sat-hadoop-api followed by BackendWorker
</ol>

<h4> Instructions to setup the Rabbit MQ</h4>
<p> sudo apt-get install rabbitmq-server </p>

