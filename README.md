# Linux-Backup-Server

1/ This Linux based project is written as a bash script file.

2/ The user will be asked to choose if they want to upload, view, or download files from another Linux server.

3/ Once the user has made their choice, they will be asked to input the destination server and the username that they want to use to log into that server.

4/ All files will be uploaded and downloaded as a tar.gz file.

5/ There are two different MySQL table that was used for this project. The first one will store all the servers that was accessed, when they was first access and latest access. The second table will be user specific, this will store the files that a specific user has uploaded to the server. This table will also store when the file was first upload and when it was last modify.

6/ The Backup Server folder includes the bash script file and a video that demonstrates how the file will be executed.
