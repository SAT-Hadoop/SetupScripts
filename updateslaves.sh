#Purpose of this script is to update the slaves list at regural intervals
source saicreds/eucarc
>/tmp/new
for i in `euscale-describe-auto-scaling-instances  | grep "Slave" | awk '{print $2}'`
do
        euca-describe-instances | grep "running" |  grep $i | awk '{print $14}' | head -1 >> /tmp/new
done
java -cp AddandUpdateAlgo/target/SlavesUpdate-1.0-SNAPSHOT.jar edu.iit.driver.Driver 2

>/tmp/newmaster
for i in `euscale-describe-auto-scaling-instances  | grep "Master" | awk '{print $2}'`
do
        euca-describe-instances | grep "running" |  grep $i | awk '{print $14}' | head -1 >> /tmp/newmaster
done
java -cp AddandUpdateAlgo/target/SlavesUpdate-1.0-SNAPSHOT.jar edu.iit.driver.Driver 1
~                          
