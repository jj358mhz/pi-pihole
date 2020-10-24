#!/usr/bin/env bash
# up_unbound: A script to automatically update you unbound root DNS server lists
# (c) 2020 jj358mhz, LLC (https://jj358mhz.com)
#
# A script to automatically update you unbound root DNS server lists.
#
# This file is copyright under the latest version of the EUPL.
# Please see LICENSE file for your rights under this license.

check_exit_status() {

	if [ $? -eq 0 ]
	then
		echo
		echo "Success"
		echo
	else
		echo
		echo "[ERROR] Process Failed!"
		echo

		read -p "The last command exited with an error. Exit script? (yes/no) " answer

            if [ "$answer" == "yes" ]
            then
                exit 1
            fi
	fi
}

greeting() {

	echo
	echo "Hello, $USER. Let's update this system."
	echo
}

update() {

        echo
        echo "Here is the contents of the old list we will be replacing..."
        echo

        sudo cat /var/lib/unbound/root.hints;

        echo
        echo "Updating to the new list..."
        echo

        sudo wget -O root.hints https://www.internic.net/domain/named.root;
        check_exit_status

        sudo mv root.hints /var/lib/unbound/;
        check_exit_status

        sudo service unbound restart;
	check_exit_status
}

housekeeping() {

	sudo cat /var/lib/unbound/root.hints;
	check_exit_status
}

leave() {

	echo
	echo "--------------------"
	echo "- Update Complete! -"
	echo "--------------------"
	echo
	exit
}

greeting
update
housekeeping
leave
