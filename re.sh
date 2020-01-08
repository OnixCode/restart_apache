#!/bin/bash

# Move the current execution stat to the proper directory
cd /etc/apache2/sites-available

# Disable a vhost configuration
sudo a2dissite *
sudo service apache2 restart

# Enable a vhost configuration
sudo a2ensite *
sudo service apache2 restart