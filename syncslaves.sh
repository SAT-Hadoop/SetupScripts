# to sync slaves

touch dummyfile
for i in `cat $HOME/hadoop-2.6.0/etc/hadoop/slaves`
do
	scp -i ./hadoopeuca.pem ~/.ssh/* root@$i:~/.ssh
	if [ "$i" != "master" ]
		then

		ssh -i ./hadoopeuca.pem root@$i 'bash -s' < setup-hadoop.sh

	fi
done