# INTRO INTO GIT
Right now you are cloning or downloading files. Wouldn't it be nice to just pull the latest updates to 1 folder that doesnt change. 
Lets say you have a folder called X and you save a file into of your own called "myawesomework". Then you need to download new updates
from Git without losing that material. There is a way to do it but it's a few steps and just like Salsa or Swing dancing it can take a bit
to get use to. 

#### Let's start with Downloading Gitbash
Gitbash is like command line and its a way to manage your own repositories on your PC. Think of it like Github but just for you on your device.

*You can download Gitbash here:
https://git-scm.com/downloads

There are few things to learn when using Git on your device one is command line language the other is version control or workflows the other is 
how that all works in Git. 
We wont go into to much detail on that. Mainly just want to get you set up and able to refresh without overwriting your current work. 
Many of these steps you can do in Git command line but let's keep it simple for now. 

1. Create a new folder on your desktop called DataAnalytics

2. In Gitbash navigate to your new folder using 

  a. you can navigate to your folder using cd path/folder/ 

3. once in your folder directory type "Git init" this initializes a git repository in that folder.

4. git pull https://github.com/Morrisdata/DataScience101.git

  a. This may work smoothly for you or cause a series of different error messages. What you are doing is connecting to git and pulling      all the info from that repository on to your desktop. Pretty powerful stuff but can be buggy. 

b. To pull git hub data you may need to configure your git repo
     git config --global http.sslverify false

5. Next step for now will be using this repo as a download spot. You can run a git pull to get the latest updates quickly.

6. Any worksheets you want to work off of you can move into a new workfolder and your changes will be saved. Look at your repo as data that cannot be changed and your other folder as a working one where you can move what you want ane leave the rest. 

This is a small step towards using Gits full potential. To find out more check out:
https://www.codecademy.com/learn/learn-git Git tutorial
https://www.codeschool.com/courses/try-git Additional practice

  
Couple of quick commands in CMD git bash you can use
* pwd  Present working directory
* ls      list files directories and subdirectories
* cd     Change directory
* cd path/  Change directory and path name
* mkdir- make a new directory
* Git init – initialize new git repository
