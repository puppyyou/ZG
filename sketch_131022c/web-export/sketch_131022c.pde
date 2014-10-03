import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import processing.video.*;
import processing.serial.*;

Serial myPort; 
Capture video;
//knobValue1 myPort;// no need
//knbValue2 myPort; //no need

Minim minim;
AudioOutput out;
AudioSample samples[];

color lastFrame[];

float threshold = 60;

float knobValue1 = 0;
float knobValue2 = 0;

int captureWidth = 640;
int captureHeight = 480;

int zoneWidth = 16;
int zoneHeight = 8;
int numSamples = zoneWidth * zoneHeight;

void setup() {
  // --Leslie --//
  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  // -- Ends of Leslie--
  
  println(Capture.list());
  video = new Capture(this, Capture.list()[6]);
  video.start();
  
  lastFrame = new color[zoneWidth * zoneHeight];
   
  minim = new Minim(this);
  out = minim.getLineOut();
  
  samples = new AudioSample[numSamples];
  
  for (int i = 0; i < zoneWidth; i++) {
    for (int j = 0; j < zoneHeight; j++) {
    }
  }
  
  size(640,480);
}



void updateKnobValues() {

  // Leslie 
//  String portName = knobValue1.list()[0];
//  String portName = knobValue2.list()[1];
  myPort = new knobValue1(this, portName, 9600);
  myPort = new knobValue2(this, portName, 9600);
  myPort.bufferUntil('\n');
  println(knobValue1);
  println(knobValue2);

}


void draw() {
  // Capture video
  if (video.available()) {
    video.read(); 
    video.loadPixels();
    
    // Create a new image of the frame scaled down
    PImage img = createImage(captureWidth, captureHeight, RGB);
    img.loadPixels();
    img.pixels = video.pixels;
    img.updatePixels();
    img.resize(zoneWidth, zoneHeight);
    img.loadPixels();
    
    for (int i = 0; i < 16 * 8; i++) {
      float r1 = red(img.pixels[i]); 
      float g1 = green(img.pixels[i]); 
      float b1 = blue(img.pixels[i]);
      float r2 = red(lastFrame[i]); 
      float g2 = green(lastFrame[i]); 
      float b2 = blue(lastFrame[i]);
      
      float diff = dist(r1,g1,b1,r2,g2,b2);
    
      if (diff > threshold) { 
       if (samples[i] != null) {   
         samples[i].trigger();
       }
      }
      lastFrame[i] = img.pixels[i];
    }
    
    image(img, 0,0, 640, 480);
   
  }
}

//////////////Leslie /////////////////////

//removed whitespace
//send the date from knob to computer

  void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    println(myString);
  }

  myString = trim(myString);
  int sensors[] = int(split(myString, ','));

  for (int sensorNum = 0; sensorNum < sensors.length;sensorNum++)
  {
    print("Sensor" + sensorNum + " : " + sensors[sensorNum] + "\t");
  }
  println();

  if (sensors.length>1) {
      knobValue1 = map(sensors[0], 0, 1023, 0, 30);
      knobValue2 = map(sensors[1], 0,1023,0,50);}
  }

