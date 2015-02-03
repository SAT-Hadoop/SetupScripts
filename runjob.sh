start-all.sh
hadoop namenode -format -force
hadoop fs -rmr /input
hadoop fs -mkdir /input
hadoop fs -rmr /output
hadoop fs -put /tmp/inputfile /input
hadoop jar /home/supramo/NetBeansProjects/MarketBasket/target/MarketBasket-1.0-SNAPSHOT.jar edu.iit.marketbasket.MarketBasket /input/inputfile /output
rm -r ./output
hadoop fs -get /output .
