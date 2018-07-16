# Project Title

Script to capture a pic from webcam upon startup of computer and save it in a folder within the home directory.

## Getting Started

The script will save a pic within the home directory. Pics will be saved up to a total number set  
by the user, at which point the picture with the oldest write date will be deleted and a new  
picture will be saved in its place.

* check for devices camera port using `ls -ltrh /dev/video*`
  - by default this is set to cameraPort = 0

* Increasing rampFrames variable will allow the webcam a longer period of time to adjust the light  
  input to the webcam

* by adjusting maxfilesToSave the user can specify the number of pics to be saved before overwriting.

To get the script to run upon startup in Ubuntu, run `sudo crontab -e` in the command line
* it is important to edit the sudo crontab file and not the user's because the picture will be taken  
  before the login screen

* Within the crontab file type `@reboot /path/to/script/startupCamScript.sh`

## Places for Improvement

* This will run on Ubuntu, should be fairly straight forward to generize to other OSs.


