#!/bin/bash
# set e will halt the shell script if there is an error
set -e 
# set x will show verbose output
set -x

# how to check if an application exists previously in a shell script
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
# note I chose Maven as the test itme because it is not commonly installed also the Maven dependency is in the pressed file for the ubuntu install

if ! hash mvn 2>/dev/null; 
  then

sudo apt-get -y update
sudo apt-get -y install vim
sudo apt-get -y install openjdk-7-jdk
sudo apt-get -y install ssh 
sudo apt-get -y install rsync
sudo apt-get -y install python-software-properties
sudo apt-get -y install curl
sudo apt-get -y install git
sudo apt-get -y install unzip
sudo apt-get -y install python-pip
sudo apt-get -y install maven
pip install awscli

fi

wget --directory-prefix=$HOME --progress=dot http://mirrors.koehn.com/apache/hadoop/common/stable/hadoop-2.6.0.tar.gz
tar -zxvf  $HOME/hadoop-2.6.0.tar.gz
echo '
export JAVA_HOME=/usr # Licensed to the Apache Software Foundation (ASF) under one or more
# User for YARN daemons
export HADOOP_YARN_USER=${HADOOP_YARN_USER:-yarn}
# resolve links - $0 may be a softlink
export YARN_CONF_DIR="${YARN_CONF_DIR:-$HADOOP_YARN_HOME/conf}"
# #=/home/y/libexec/jdk1.6.0/
if [ "$JAVA_HOME" != "" ]; then
  #echo "run java in $JAVA_HOME"
  JAVA_HOME=$JAVA_HOME
fi
if [ "$JAVA_HOME" = "" ]; then
  echo "Error: JAVA_HOME is not set."
  exit 1
fi
JAVA=$JAVA_HOME/bin/java
JAVA_HEAP_MAX=-Xmx1000m 

# For setting YARN specific HEAP sizes please use this
# Parameter and set appropriately
# YARN_HEAPSIZE=1000

# check envvars which might override default args
if [ "$YARN_HEAPSIZE" != "" ]; then
  JAVA_HEAP_MAX="-Xmx""$YARN_HEAPSIZE""m"
fi

# so that filenames w/ spaces are handled correctly in loops below
IFS=

YARN_LOG_DIR=/vol-01/hadooplogs/
# default log directory & file
if [ "$YARN_LOG_DIR" = "" ]; then
  YARN_LOG_DIR="$HADOOP_YARN_HOME/logs"
fi
if [ "$YARN_LOGFILE" = "" ]; then
  YARN_LOGFILE=yarn.log
fi

# default policy file for service-level authorization
if [ "$YARN_POLICYFILE" = "" ]; then
  YARN_POLICYFILE="hadoop-policy.xml"
fi

# restore ordinary behaviour
unset IFS

YARN_OPTS="$YARN_OPTS -Dhadoop.log.dir=$YARN_LOG_DIR"
YARN_OPTS="$YARN_OPTS -Dyarn.log.dir=$YARN_LOG_DIR"
YARN_OPTS="$YARN_OPTS -Dhadoop.log.file=$YARN_LOGFILE"
YARN_OPTS="$YARN_OPTS -Dyarn.log.file=$YARN_LOGFILE"
YARN_OPTS="$YARN_OPTS -Dyarn.home.dir=$YARN_COMMON_HOME"
YARN_OPTS="$YARN_OPTS -Dyarn.id.str=$YARN_IDENT_STRING"
YARN_OPTS="$YARN_OPTS -Dhadoop.root.logger=${YARN_ROOT_LOGGER:-INFO,console}"
YARN_OPTS="$YARN_OPTS -Dyarn.root.logger=${YARN_ROOT_LOGGER:-INFO,console}"
if [ "x$JAVA_LIBRARY_PATH" != "x" ]; then
  YARN_OPTS="$YARN_OPTS -Djava.library.path=$JAVA_LIBRARY_PATH"
fi  
YARN_OPTS="$YARN_OPTS -Dyarn.policy.file=$YARN_POLICYFILE"


' > $HOME/hadoop-2.6.0/etc/hadoop/yarn-env.sh

echo '
export JAVA_HOME=/usr # Licensed to the Apache Software Foundation (ASF) under one
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}
export HADOOP_HOME=/root/hadoop-2.6.0/
# Extra Java CLASSPATH elements.  Automatically insert capacity-scheduler.
for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar; do
  if [ "$HADOOP_CLASSPATH" ]; then
    export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
  else
    export HADOOP_CLASSPATH=$f
  fi
done
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true"
export HADOOP_NAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_NAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,RFAS $HADOOP_DATANODE_OPTS"
export HADOOP_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_SECONDARYNAMENODE_OPTS"

export HADOOP_NFS3_OPTS="$HADOOP_NFS3_OPTS"
export HADOOP_PORTMAP_OPTS="-Xmx512m $HADOOP_PORTMAP_OPTS"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="-Xmx512m $HADOOP_CLIENT_OPTS"
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

export HADOOP_SECURE_DN_USER=${HADOOP_SECURE_DN_USER}

# Where log files are stored.  $HADOOP_HOME/logs by default.
export HADOOP_LOG_DIR=/vol-01/hadooplogs/

# Where log files are stored in the secure data environment.
export HADOOP_SECURE_DN_LOG_DIR=${HADOOP_LOG_DIR}/${HADOOP_HDFS_USER}

export HADOOP_PID_DIR=${HADOOP_PID_DIR}
export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}

# A string representing this instance of hadoop. $USER by default.
export HADOOP_IDENT_STRING=$USER

' > $HOME/hadoop-2.6.0/etc/hadoop/hadoop-env.sh


echo "
<configuration>
<property>
  <name>fs.default.name</name>
  <value>hdfs://master:54310</value>
  <description>The name of the default file system.  A URI whose
  scheme and authority determine the FileSystem implementation.  The
  uri's scheme determines the config property (fs.SCHEME.impl) naming
  the FileSystem implementation class.  The uri's authority is used to
  determine the host, port, etc. for a filesystem.</description>
</property>
</configuration>
" > $HOME/hadoop-2.6.0/etc/hadoop/core-site.xml

echo "
<!-- In: conf/hdfs-site.xml -->
<configuration>
<property>
  <name>dfs.replication</name>
  <value>1</value>
  <description>Default block replication.
  The actual number of replications can be specified when the file is created.
  The default is used if replication is not specified in create time.
  </description>
</property>
<property>       
 <name>dfs.name.dir</name>       
 <value>/vol-01/hadoop/hdfs/nn</value>  
 <description>Comma separated list of paths. Use the list of directories from $DFS_NAME_DIR.  
                For example, /grid/hadoop/hdfs/nn,/grid1/hadoop/hdfs/nn.</description>
</property>
<property>       
 <name>dfs.data.dir</name>       
 <value>/vol-01/hadoop/hdfs/dn</value>
 <description>Comma separated list of paths. Use the list of directories from $DFS_NAME_DIR.  
                For example, /grid/hadoop/hdfs/nn,/grid1/hadoop/hdfs/nn.</description>
</property>
</configuration>

" > $HOME/hadoop-2.6.0/etc/hadoop/hdfs-site.xml

echo "
<configuration>
<property>
  <name>mapred.job.tracker</name>
  <value>master:54311</value>
</property>
<property>
  <name> mapreduce.framework.name</name>
  <value>yarn</value>
</property>
<property>
    <name>mapred.compress.map.output</name>
    <value>true</value>
</property>
<property>
    <name>mapred.map.output.compression.codec</name>
    <value>com.hadoop.compression.lzo.LzoCodec</value>
</property>
<property>
    <name>io.sort.mb</name>
    <value>800</value>
</property>
<property>
<name>mapreduce.map.memory.mb</name>
<value>600</value>
</property>
<property>
<name>mapreduce.reduce.memory.mb</name>
<value>600</value>
</property>
<property>
<name>mapreduce.map.java.opts</name>
<value>-Xmx500m</value>
</property>
</property>
<name>mapreduce.reduce.java.opts</name>
<value>-Xmx500m</value>
</configuration>

" > $HOME/hadoop-2.6.0/etc/hadoop/mapred-site.xml

echo "
 <configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
  <property>
    <name>yarn.resourcemanager.resource-tracker.address</name>
    <value>master:8025</value>
  </property>
  <property>
    <name>yarn.resourcemanager.scheduler.address</name>
    <value>master:8030</value>
  </property>
  <property>
    <name>yarn.resourcemanager.address</name>
    <value>master:8040</value>
  </property>
 <property>
  <name>yarn.nodemanager.resource.memory-mb</name>
  <value>1600</value>
</property>
<property>
<name>yarn.scheduler.minimum-allocation-mb</name>
<value>600</value>
</property>
 </configuration>

" > $HOME/hadoop-2.6.0/etc/hadoop/yarn-site.xml

echo "
export JAVA_HOME=/usr
export PATH=$PATH:$HOME/hadoop-2.6.0/bin:$HOME/hadoop-2.6.0/sbin:/usr
" >> $HOME/.bashrc

cat $HOME/hadoop-2.6.0/etc/hadoop/hadoop-env.sh | sed 's/export JAVA_HOME/#/' > tmp
(echo -n 'export JAVA_HOME=/usr '; cat tmp) > $HOME//hadoop-2.6.0/etc/hadoop/hadoop-env.sh

cat $HOME/hadoop-2.6.0/etc/hadoop/mapred-env.sh | sed 's/export JAVA_HOME/#/' > tmp
(echo -n 'export JAVA_HOME=/usr '; cat tmp) > $HOME//hadoop-2.6.0/etc/hadoop/mapred-env.sh

cat $HOME/hadoop-2.6.0/etc/hadoop/yarn-env.sh | sed 's/export JAVA_HOME/#/' > tmp
(echo -n 'export JAVA_HOME=/usr '; cat tmp) > $HOME//hadoop-2.6.0/etc/hadoop/yarn-env.sh

ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
sudo chmod 777 /etc/ssh/ssh_config
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config
source ~/.bashrc
sudo chmod 777 /etc/hosts
echo "`/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}'` master" >> /etc/hosts
echo "master" > $HOME//hadoop-2.6.0/etc/hadoop/slaves
$HOME/hadoop-2.6.0/sbin/stop-all.sh
$HOME/hadoop-2.6.0/bin/hadoop master -format -force
#$HOME/hadoop-2.6.0/sbin/start-all.sh
