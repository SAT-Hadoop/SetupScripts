sudo apt-get update
sudo apt-get -y vim
sudo apt-get -y install openjdk-7-jdk
sudo apt-get -y install ssh 
sudo apt-get -y install rsync
sudo apt-get -y install python-software-properties
sudo apt-get -y install curl
sudo apt-get -y install git
sudo apt-get -y install unzip
sudo apt-get -y install python-pip
pip install awscli
cd $HOME
wget http://mirrors.koehn.com/apache/hadoop/common/stable/hadoop-2.6.0.tar.gz
tar -zxvf  hadoop-2.6.0.tar.gz

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
</configuration>
" > $HOME/hadoop-2.6.0/etc/hadoop/hdfs-site.xml

echo "
<!-- In: conf/mapred-site.xml -->
<configuration>
<property>
  <name>mapred.job.tracker</name>
  <value>master:54311</value>
  <description>The host and port that the MapReduce job tracker runs
  at.  If "local", then jobs are run in-process as a single map
  and reduce task.
  </description>
</property>
</configuration>
" > $HOME/hadoop-2.6.0/etc/hadoop/mapred-site.xml

echo"
<?xml version="1.0"?>
<configuration>
  <property>
    <name>yarn.resourcemanager.resource-tracker.address</name>
    <value>namenode:8031</value>
  </property>
  <property>
    <name>yarn.resourcemanager.address</name>
    <value>namenode:8032</value>
  </property>
  <property>
    <name>yarn.resourcemanager.scheduler.address</name>
    <value>namenode:8030</value>
  </property>
  <property>
    <name>yarn.resourcemanager.admin.address</name>
    <value>namenode:8033</value>
  </property>
  <property>
    <name>yarn.resourcemanager.webapp.address</name>
    <value>namenode:8088</value>
  </property>
</configuration>

"> $HOME/hadoop-2.6.0/etc/hadoop/yarn-site.xml




echo "
export JAVA_HOME=/usr
export PATH=$PATH:$HOME/hadoop-2.6.0/bin:$HOME/hadoop-2.6.0/sbin:/usr
" >> ~/.bashrc

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
$HOME/hadoop-2.6.0/bin/hadoop namenode -format -force
#$HOME/hadoop-2.6.0/sbin/start-all.sh
