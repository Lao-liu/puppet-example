#!/bin/sh
#load config
. ./conf.ini

########################### functions start ###########################
function user_confirm() {
	local rand_string=`date | md5sum`
	local secret=${rand_string:8:3}
	
	echo "---------- WARNING ----------
	
	This is an initial script O-N-L-Y for new barebone, it will erase your config and data.
	
	Please repeat the following random number for comfirmation
	the random number is : 
	
	        ${secret}
	
	please enter it: "
	read string
	
	local comfirm_input="${string}"
	
	if [ ${comfirm_input} != ${secret} ]
	then
		echo "The random number you entered does not match, exiting..."
		exit
	fi
}

function set_hostname() {
	if [ ! -z $1 ]; then
		hostname $1
		sed -i -e "s/HOSTNAME=.*/HOSTNAME=$1/" /etc/sysconfig/network
		echo your hostname has been set to $1
	else
		echo Internal error, empty parameter passed -_-
	fi

}

function set_ip() {
	echo "IP address will be: " $ip
	
	#set ip and restart
	sed -i -e "s/IPADDR=.*/IPADDR=$ip/" /etc/sysconfig/network-scripts/ifcfg-eth0
	
	echo "restarting network..."
	# restart network
	service network restart
}

function rm_ca {
        hostname=`hostname`

        rm /var/lib/puppet/ssl/* -rf
        ssh $puppet_server "puppet cert --clean $hostname"
}

function print_usage() {
        echo "Usage: init.sh task [hostname], for example:
        init.sh init_vm test.sb
        init.sh set_ip test.sb
        init.sh rm_ca"
}
########################### functions end ###########################

########################### Entrance ###########################
if [ -z $1 ]; then
        print_usage
        exit
fi

case $1 in
        "init_vm" )
                if [ -z $2 ]; then
                        print_usage
                        exit
                fi
                user_confirm
                rm_ca $2
                set_hostname $2
                set_ip $2
        ;;

        "set_ip" )
                if [ -z $2 ]; then
                        print_usage
                        exit
                fi
                set_ip $2
        ;;

        "rm_ca" )
                rm_ca
        ;;

        * ) echo "task must be: init_vm, set_ip, rm_ca"
esac
