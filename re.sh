#!/bin/bash

# Represents the virtual-host files
CONFIG="$1"

# Represents the restart|reload command
COMMAND="$2"

# Checks to see if user input is a valid virtual-host name
FILEMATCH=false

# Variable to hold the virtual host file name for comparison
VALID_VHOSTS=''

#Require two parameters to proceed
if [ $# -ne 2 ]
then
    echo -e "\e[33;40;1;5mERROR:\e[0m The script \e[100m$0\e[0m requires two parameters {\e[94mvirtual-host\e[0m} {\e[95mrestart|reload\e[0m}"
    exit 1
fi

# List all of the configuration files in the
#_/etc/apache2/sites-available/_ directory
VHOSTS_PATH=/etc/apache2/sites-available/*.conf 

# Set variable FILENAME to iterate through list of configuration files
# in VHOSTS_PATH. 
for FILENAME in ${VHOSTS_PATH}
do
# Must seperate the data from VHOSTS_PATH into FILENAME in order to display the
# data correctly 
    if [ -z "$VALID_VHOSTS" ]
        then
        #Only displays filename section of the path
            VALID_VHOSTS="${FILENAME:29:-5}"
        else
        VALID_VHOSTS="${VALID_VHOSTS}|${FILENAME:29:-5}"
        fi

    if [ "$FILENAME" == "/etc/apache2/sites-available/${CONFIG}.conf" ]
    then
        FILEMATCH=true
        break
    fi
done

if [ $FILEMATCH == false ]
then
    echo -e "\e[33;40;1;5mERROR:\e[0m The filename \e[100m$CONFIG\e[0m is an invalid virtual-host file. 
    Valid entries {\e[94m$VALID_VHOSTS\e[0m}"
    exit 1
fi

#Only allow reload of restart for COMMAND
if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
then

#Move the current execution state to the proper directory
cd /etc/apache2/sites-available

#Disable a vhost configuration
sudo a2dissite "$CONFIG"
sudo service apache2 "$COMMAND"
systemctl reload apache2

#Enable a vhost configuration
sudo a2ensite "$CONFIG"
sudo service apache2 "$COMMAND"
systemctl reload apache2

else
    echo -e "\e[33;40;1;5mERROR:\e[0m The command \e[100m$COMMAND\e[0m is an invalid service command {\e[95mrestart|reload\e[0m}"
    exit 1
fi