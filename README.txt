=============================================
The Adaptive Path Fridge Alarm
 
created September 2010
modified Dec 2012
by Dane Petersen
 
http://adaptivepath.com/ideas/adaptive-path-fridge-alarm
=============================================

TO INSTALL:

1. Drag the fridge_alarm folder into your Arduino sketchbook. You can find the location of your sketchbook from within the Preferences dialog in the Arduino software.

2. Drag the contents of the libraries folder into the libraries folder in your Arduino sketchbook, if it already exists. If the libraries folder does not exist, create it. More information on installing third-party libraries is available on the Arduino website at http://arduino.cc/en/Guide/Environment#libraries

2.1 The Fridge Alarm code depends on two libraries, Bounce and Tone. Bounce can be downloaded at http://arduino.cc/playground/uploads/Code/Bounce.zip while Tone can be downloaded at http://rogue-code.googlecode.com/files/Arduino-Library-Tone.zip

2.2 Note that the version of the Tone library included in this zip file has been patched to work with Arduino 1.0. If you try to use the version from Google Code you will get an error when you try to verify the script. Follow the instructions at http://arduino.cc/forum/index.php/topic,87398.0.html to patch the downloaded version (change wiring.h to Arduino.h on line 26 of Tone.cpp) or simply use the Tone library included here.

3. Using the Fritzing diagram as a guide, wire up your Arduino. You can download the Fritzing application at http://fritzing.org/download/

4. Open the fridge_alarm sketch in the Arduino software, and upload it to your Arduino. You may need to disconnect pins 0 and 1 to get it to upload correctly.

5. Try and try again, and remember... this is supposed to be fun!