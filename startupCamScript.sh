#!/usr/bin/python
import cv2
import getpass
import os
from os.path import isfile, join
import datetime
import re

cameraPort = 0
rampFrames = 5 # number of frames to throw away while the camera adjusts to light levels
maxfilesToSave = 10 # maximum number of files to save

# Initialize the camera capture object.
camera = cv2.VideoCapture(cameraPort)
 
# Captures a single image from the camera and returns it in PIL format
def get_image():
    # read gives a full image out of a VideoCapture object.
    retval, im = camera.read()
    return im
 
# Ramp the camera - these frames will be discarded and are only used to allow v4l2
# to adjust light levels, if necessary
for i in range(rampFrames):
    temp = get_image()

# Take the actual image we want to keep
cameraCapture = get_image()


# file is named based on date which script is run
timeFormat = "%Y-%m-%d_%H:%M"
now = datetime.datetime.now()
date =now.strftime(timeFormat)
namLab = 'cameraPic'
fileName = namLab + '_{date}'.format(date=date,fmt='%s')
fileType = '.png'
#cwd = os.getcwd()
#dirName = os.path.join(cwd,'picFoldr')
dirName = os.path.join('/home','picFoldr')
fullAddress = os.path.join(dirName, fileName + fileType)


# check if directory exists, if not creates it
if not os.path.exists(dirName):
    os.makedirs(dirName)

# check to see if number of files in given directory is below the maximum number given above
# if maximum number of files has not been exceeded save file
# if maximum number of files has been exceeded delete file which was created first and save

# creates a regular expression object with a file name which matches pattern of the filename defined above
regex = re.compile(namLab + '_(\d*-\d*-\d*_\d*:\d*)')

def getTimeStamp(fullAddOfFile):
    #search input address for a string matching the pattern defined in regex 
    match = regex.search(fullAddOfFile)
    dateFromFileName=match.groups()[0]
    #create a string representing the date formatted according to timeFormat defined above
    return datetime.datetime.strptime(dateFromFileName, timeFormat)

# create an array of the full file paths of all of the folders in predefined directory
onlyfilesFull = [os.path.join(dirName,fileName) for fileName in os.listdir(dirName) if isfile(join(dirName, fileName))]

# sort the file names in onlyfilesFull according to creation date extracted from the file name
dateSortedList = [fn for fn in sorted(onlyfilesFull, key=getTimeStamp)]

# if the maximum number of files has not been exceeded save the file, if it has been exceeded 
# remove the file with the oldest creation date and then save the new file
if len(dateSortedList)<maxfilesToSave:
    if not os.path.exists(fullAddress):
        cv2.imwrite(fullAddress, cameraCapture)   
else:
    if not os.path.exists(fullAddress):
        os.remove(dateSortedList[0])
        cv2.imwrite(fullAddress, cameraCapture)


# Releases the camera, otherwise you won't be able to create a new
# capture object until your script exits
del(camera)
