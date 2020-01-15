#!/bin/bash

# Variables for virtual host and server command parameters
CONFIG="$1"
COMMAND="$2"
# Array of valid server command parameters
COMMAND_OPT=( restart reload )
# File path of valid virtual hosts
VHOSTS_PATH=/etc/apache2/sites-available/*.conf
# Testing condition for virtual host and server command parameter match
VHOST_TEST=false
CMD_TEST=false
# Empty variable set to hold iterations of virtual host and server command parameters
HOST_FILE=""
SERVER_CMD=""
# Test for two parameters included in script execution
if [ $# -ne 2 ]
then
    echo -e "\e[107;31;5mERROR\e[0m: $0 requires two parameters {\e[33mvirtual-host\e[0m} {\e[33mrestart|reload\e[0m}"
    exit 1
fi
# Loop through each virtual host in the VHOST_PATH
for FILENAME in ${VHOSTS_PATH}
do  
# Check that HOST_FILE is empty, then, for each virtual host, append the amended file path (virtual host name), into HOST_FILE
    if [ -z = "$HOST_FILE" ]
    then
        HOST_FILE="${FILENAME:29:-5}"
    else
        HOST_FILE="${HOST_FILE}"$'\n'"${FILENAME:29:-5}"   
    fi
# If the entered virtual host matches a virtual host in the path below, set the testing condition to true and stop looping
    if [ "$FILENAME" == "/etc/apache2/sites-available/${CONFIG}.conf" ]
    then
        VHOST_TEST=true  
    break
    fi
done
# Error message if the entered virtual host doesn't match a virtual host within the file path
if [ $VHOST_TEST == false ]
then 
    echo -e "\e[107;31;5mERROR\e[0m: The virtual host, \e[4m$CONFIG\e[0m is an invalid virtual host. Valid options are: $HOST_FILE"
    exit 
fi
# Loop through each server command in the COMMAND_OPT
for OPTIONS in "${COMMAND_OPT[@]}"
do
# Check that SERVER_CMD is empty, then, for each server command within the COMMAND_OPT array, append it into SERVER_CMD
    if [ -z = "$SERVER_CMD" ]
    then
        SERVER_CMD="${OPTIONS}"
    else
        SERVER_CMD="${SERVER_CMD}|${OPTIONS}"
    fi  
# If the entered server command matches a a command within the array, set the testing condition to true and stop looping
    if [ "$OPTIONS" == "$COMMAND" ]
    then
        CMD_TEST=true
    break  
    fi
done
# Error message if the entered server command doesn't match a server command within the array
if [ $CMD_TEST == false ]
then
    echo -e "\e[107;31;5mERROR\e[0m: The requested command, \e[4m$COMMAND\e[0m is an invalid service command."
    exit
fi
# Execute the script if both testing conditions are true
if [ $VHOST_TEST == true ] && [ $CMD_TEST == true ]
then
    # Move the current execution state to the proper directory
    cd /etc/apache2/sites-available

    # Disable a vhost configuration
    sudo a2dissite "$CONFIG"
    sudo service apache2 "$COMMAND"

    # Enable a vhost configuration
    sudo a2ensite "$CONFIG"
    sudo service apache2 "$COMMAND"
fi      

