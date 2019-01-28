/**
* REALLY simple processing sketch for using webcam input
* This sends 100 input values to port 6448 using message /wek/inputs
**/

import processing.video.*;
import oscP5.*;
import netP5.*;

int numPixelsOrig;
int numPixels;
boolean first = true;

float threshMult = 1;
int boxWidth = 16;
int boxHeight = 12;
int sliderDim = 100;
boolean overBox = false;
boolean locked = false;

int resHor = 640;
int resVert = 480;

float meanC = 0;
int totPix = resHor*resVert;

int numHoriz = resHor/boxWidth;
int numVert = resVert/boxHeight;

float bx;
float by;
float byDefault = resVert/2.0-sliderDim/2;
float byMin = 0;
float byMax = resVert-sliderDim;
float bxLock = 640;

float yOffset = 0.0;
int firstRun = 1;
float threshold;

color[] downPix = new color[numHoriz * numVert];


Capture video;

OscP5 oscP5;
NetAddress dest;
NetAddress dest2;

void setup() {
 // colorMode(HSB);
  size(740, 480, P2D);
  bx = bxLock;
  by = byDefault;
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, resHor, resVert);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
   /* println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    } */

   video = new Capture(this, resHor, resVert);
    
    // Start capturing the images from the camera
    video.start();
    
    numPixelsOrig = video.width * video.height;
    loadPixels();
    noStroke();
  }
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
  dest2 = new NetAddress("127.0.0.1",6449);
  
}

void draw() {
  background(255);
  fill(255);

  
  if (video.available() == true) {
    video.read();
    
    video.loadPixels(); // Make the pixels of video available
    /*for (int i = 0; i < numPixels; i++) {
      int x = i % video.width;
      int y = i / video.width;
      float xscl = (float) width / (float) video.width;
      float yscl = (float) height / (float) video.height;
      
      float gradient = diff(i, -1) + diff(i, +1) + diff(i, -video.width) + diff(i, video.width);
      fill(color(gradient, gradient, gradient));
      rect(x * xscl, y * yscl, xscl, yscl);
    } */
  int boxNum = 0;
  int tot = boxWidth*boxHeight;
  if (firstRun ==1){

    for (int i = 0; i<totPix; i++){
      meanC += red(video.pixels[i])+green(video.pixels[i])+blue(video.pixels[i]);
      
    }
    meanC = threshMult*meanC/totPix;
    threshold = meanC;
    //by = (255/threshold)*(resVert/2.0)-sliderDim/2;
    firstRun = 0;
  }
  for (int x = 0; x < resHor; x += boxWidth) {
     for (int y = 0; y < resVert; y += boxHeight) {
        float red = 0, green = 0, blue = 0;
        
        for (int i = 0; i < boxWidth; i++) {
           for (int j = 0; j < boxHeight; j++) {
              int index = (x + i) + (y + j) * resHor;
              red += red(video.pixels[index]);
              green += green(video.pixels[index]);
              blue += blue(video.pixels[index]);
           } 
        }
       //downPix[boxNum] =  color(red/tot, green/tot, blue/tot);
       float gray = sqrt(pow((red/tot),2)+ pow((green/tot),2)+ pow((blue/tot),2));
       if (gray>threshold){
         downPix[boxNum] =  color(255);  
       } else{
         downPix[boxNum] =  color(0);  
       }
       //downPix[boxNum] =  color( sqrt(pow((red/tot),2)+ pow((green/tot),2)+ pow((blue/tot),2)) );
      // downPix[boxNum] = color((float)red/tot, (float)green/tot, (float)blue/tot);
       fill(downPix[boxNum]);
       
       int index = x + resHor*y;
       red += red(video.pixels[index]);
       green += green(video.pixels[index]);
       blue += blue(video.pixels[index]);
      // fill (color(red, green, blue));
       rect(x, y, boxWidth, boxHeight);
       boxNum++;
      /* if (first) {
         println(boxNum);
       } */
     } 
  }
  if(frameCount % 2 == 0)
    sendOsc(downPix);

  }
  first = false;
  fill(0);
  text("Sending 100 inputs to port 6448 using message /wek/inputs", 10, 10);
  
  
  if (mouseX > bx-sliderDim && mouseX < bx+sliderDim && 
      mouseY > by-sliderDim && mouseY < by+sliderDim) {
    overBox = true;  
    if(!locked) { 
      fill(0, 255, 0);
    } 
  } else {
    fill(0, 255, 0);
    overBox = false;
  }
  fill(0, 255, 0);
  rect(bx, by, sliderDim, sliderDim);
}

float diff(int p, int off) {
  if(p + off < 0 || p + off >= numPixels)
    return 0;
  return red(video.pixels[p+off]) - red(video.pixels[p]) +
         green(video.pixels[p+off]) - green(video.pixels[p]) +
         blue(video.pixels[p+off]) - blue(video.pixels[p]);
}

void sendOsc(int[] px) {
  OscMessage msg = new OscMessage("/wek/inputs");
 // msg.add(px);
   for (int i = 0; i < px.length; i++) {
      msg.add(float(px[i])); 
   }
  oscP5.send(msg, dest);
  oscP5.send(msg, dest2);
}


void mousePressed() {
  if(overBox) { 
    locked = true; 
    fill(0, 255, 0);
  } else {
    locked = false;
  }

  yOffset = mouseY-by; 

}

void mouseDragged() {
  if(locked) {
    bx = bxLock; 
    by = mouseY-yOffset; 
    if(by>byMax){
      by = byMax;
    }else if(by<byMin){
      by = byMin;
    }
    //threshMult = by/byDefault;
    threshold = meanC*by/byDefault;
  }
}

void mouseReleased() {
  locked = false;
}
