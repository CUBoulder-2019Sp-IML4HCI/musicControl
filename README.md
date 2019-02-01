# musicControl
Uses webcam to map hand positions to music player controls

install node

run server using command node server.js in the folder containing server.js

if it lacks dependencies, run npm install

install and open vlc media player. 

Go to tools->
preferences-> tick the circle 'All' Under show settings
->main interfaces (click on)-> tick web ->
drop down main interfaces -> select lua ->
set lua http password to 1337

close and reopen vlc. enter 'localhost:8080' into a browser

used the eject looking button to load up music files.

open kadenze classifier in musicControl.

open EvenBetterVideoInputWithProcessing_1600Inputs. This version thresholds the image, ideally reducing the video to foreground a background pixels
Adjust threshold until only your face and hands are white. You can click your hand to set your skin tone as ideal white.
If thresholding doesn't work due to a background close to your skin tone, you can also use simpeVideoInputwithProcessing-1600Inputs.


run from the source

open kadenze

you will need to open two models. Open gestureControl and volumeControl. They should have the below settings, you just need to retrain
gestureControl should have default port settings
volumeControl should listen on port 6449 and output messages to port 12000 with message /wek/outputs2


For gestureControl, gestures are as follows:
1: nothing. User is sitting still
2: point back. Plays previous song
3: point forward. Plays next song
4: open hand, center frame. Pauses or plays the music
5: make a fist with the right hand and make flat plane with your left hand. Move the left hand plane up and down to control volume.

For volume control, train it with your left hand as a plane at various heights, with a value corresponding to the height. 1 should be the highest and 0 the lowest.

Volume control will only change volume when gestureControl is outputting 5.

https://www.youtube.com/watch?v=Z0YdeS9oSXw


