#!/bin/bash/

#Ask for username
	echo "Hello, please enter your username."
	read username

#Ask if the user want to upload, view, or download a file
	echo "Hello $username! Do you want to upload, view, or download a file?"
	read choice
        echo "Please enter the destination server."
        read server
	ssh $username@$server "mkdir -p ./upload"

	if [[ "$choice" == *"upload"* ]]; then
		echo "You have chosen to upload a file! Please enter the file directory on your local computer."
		read directory

		if [ -e "$directory" ]; then
			name="${directory##*/}"
			file="$name.tar.gz"
			tar -czvf $file $directory
			scp $file $username@$server:./upload

			mysql --host=34.123.252.136 --user=root --password=root123 --database=user_database <<-EOF
        		set @@session.time_zone='-05:00';
			create table if not exists $username(
                		server VARCHAR(100),
                		file_name VARCHAR(100),
                		first_backup DATETIME,
                		latest_backup DATETIME
       			);

        		insert into $username (server, file_name) select * from (select '$server', '$file') as tmp where not exists (select file_name from $username where file_name='$file') limit 1;

                	update $username
                	set     latest_backup = now(),
                        	first_backup = 
                                	case
                                	when first_backup is null then
                                        	now()
                                	else
                                        	first_backup
                                	end
                	where server = '$server' and file_name = '$file';
			EOF
		else
			echo "File does not exist"
		fi
	
	elif [[ "$choice" == *"view"* ]]; then
		echo "You have chosen to view files! Here are your files!"
		ssh $username@$server ls ./upload

	elif [[ "$choice" == *"download"* ]]; then
		echo "You have chosen to download a file! Please enter the file that you want to download to your local computer (do not include tar.gz extension)."
		read dname
		dfile="$dname.tar.gz"
		mkdir -p ./download
		scp $username@$server:./upload/$dfile ./download
				
	else
		echo "Invalid input! Please try again!"
	fi

	mysql --host=34.123.252.136 --user=root --password=root123 --database=user_database <<-EOF
	set @@session.time_zone='-05:00';
        create table if not exists user_info(
        	username VARCHAR(100),
                server VARCHAR(100),
                first_backup DATETIME,
                latest_backup DATETIME
        );

       	insert into user_info (username, server) select * from (select '$username', '$server') as tmp where not exists (select server from user_info where server='$server') limit 1;

        update user_info
       	set     latest_backup = now(),
                first_backup = 
                          case
                          	when first_backup is null then
                                	now()
                               	else
                                        first_backup
                                end
       	where username = '$username' and server = '$server';
	EOF
