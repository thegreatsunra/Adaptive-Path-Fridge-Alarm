/*
 The Adaptive Path Fridge Alarm

 fridge_alarm.pde
 
 created September 2010
 modified Mar 2011
 by Dane Petersen
 
 http://adaptivepath.com/ideas/adaptive-path-fridge-alarm

*/

/* LIBRARIES REQUIRED BY THIS SKETCH */

// download and place these in a folder called 'libraries' in your arduino sketchbook folder
// more information about installing libraries at http://www.arduino.cc/en/Reference/Libraries
// Bounce - http://www.arduino.cc/playground/Code/Bounce
// Tone - http://code.google.com/p/rogue-code/downloads/detail?name=Arduino-Library-Tone.zip
#include <Bounce.h>
#include <Tone.h>

/* VARIABLES YOU MAY WANT TO CHANGE */

// set the pin for the door sensor
// the hall effect sensor i've been using only works on digital pins 0 or 1
// the arduino uses pins 0 and 1 for serial communication, so if you are having trouble uploading your sketch, try unplugging the sensor from these pins when you do the transfer
const int sensorPin = 1;

// set the pin for the testing led
const int ledPin = 13;

// set the pin for the piezoelectric speaker
const int speakerPin = 8;

// how long the timer should go before the alarm sounds, in milliseconds
// because of weirdness with arduino, the longest delay you can specify here is 65 seconds
// currently set at 60 seconds ... i recommend you make it shorter for testing purposes
unsigned int timerLength = (60 * 1000);

// arduino hates doing math problems to declare variables for long data types, but they're the only way to get a delay longer than 65 seconds
// if you hate the earth, you can give yourself more time to leave the fridge open with the following line, currently set at 120 seconds:
// unsigned long timerLength = 120000;

// set the blink interval for the testing led
unsigned int ledBlinkInterval = 200;

// define the song, currently "take on me"
char *song = "TakeOnMe:d=4,o=4,b=160:8f#5,8f#5,8f#5,8d5,8p,8b,8p,8e5,8p,8e5,8p,8e5,8g#5,8g#5,8a5,8b5,8a5,8a5,8a5,8e5,8p,8d5,8p,8f#5,8p,8f#5,8p,8f#5,8e5,8e5,8f#5,8e5";
// here's burgertime, as an alternative:
// char *song = "BurgerTime:d=4,o=6,b=285:8f,8f,8f#,8f#,8g#,8g#,8a,8a,a#,f,a#,f,8g#,8c#7,8c7,8a#,8g#,8g,8g#,8g,g#,c#7,g#,c#7,g#,f7,g#,f7,g#,d#7,g#,c#7,g#,d#7,g#,c#7";
// more songs are available here: http://merwin.bespin.org/db/rts/
// and here: http://www.2thumbswap.com/members/tones/nokia/tones_nokia_main.html

/* VARIABLES YOU PROBABLY SHOULD NOT CHANGE */
/* (unless you're doing something pretty awesome) */

int currentDoorState = LOW;
int previousDoorState = HIGH;
int ledState = LOW;
unsigned long timerStartTime = 0;
unsigned long timerCurrentTime = 0;
unsigned long ledCurrentTime = 0;
unsigned long ledPreviousTime = 0;

/* INITIATE ALL THE COOL THINGS */

// initiate and debounce any inputs from the sensor
Bounce sensorBouncer = Bounce(sensorPin, 1000);
// initiate the tone class
Tone speakerToner;

// initiate the music note variables
#define isdigit(n) (n >= '0' && n <= '9')
#define OCTAVE_OFFSET 0
int notes[] = { 0,
NOTE_C4, NOTE_CS4, NOTE_D4, NOTE_DS4, NOTE_E4, NOTE_F4, NOTE_FS4, NOTE_G4, NOTE_GS4, NOTE_A4, NOTE_AS4, NOTE_B4,
NOTE_C5, NOTE_CS5, NOTE_D5, NOTE_DS5, NOTE_E5, NOTE_F5, NOTE_FS5, NOTE_G5, NOTE_GS5, NOTE_A5, NOTE_AS5, NOTE_B5,
NOTE_C6, NOTE_CS6, NOTE_D6, NOTE_DS6, NOTE_E6, NOTE_F6, NOTE_FS6, NOTE_G6, NOTE_GS6, NOTE_A6, NOTE_AS6, NOTE_B6,
NOTE_C7, NOTE_CS7, NOTE_D7, NOTE_DS7, NOTE_E7, NOTE_F7, NOTE_FS7, NOTE_G7, NOTE_GS7, NOTE_A7, NOTE_AS7, NOTE_B7
};

/* SETUP() AND INITIATE PINS */

void setup() {
  
  pinMode(ledPin, OUTPUT);
  pinMode(sensorPin, INPUT);
  speakerToner.begin(speakerPin);
}

/* SCRIPT LOOP() */

void loop() {
   // check the door ... is it open or shut?
  currentDoorState = getCurrentDoorState();

  if (currentDoorState != previousDoorState) {
    // there's been a change in door state
    if (currentDoorState == HIGH) {
      // the door has been opened
      // start the timer
      timerStartTime = millis();
      // turn on the testing led
      digitalWrite(ledPin, HIGH);
      // for testing, play a note through the speaker
      // speakerToner.play(NOTE_C5, 100);
    }
    if (currentDoorState == LOW) {
      // the door has been closed
      // stop any music that might be playing
      // sadly, the script requires that the currently-playing loop of the song finish playing before it finally stops ... which is poor user experience!
      speakerToner.stop();
      // turn off the testing led
      digitalWrite(ledPin, LOW);
      // for testing, play a note through the speaker
     // speakerToner.play(NOTE_C4, 100);
    }
    // reset the door state
    previousDoorState = currentDoorState;
  }

  else {
    // the door state has remained unchanged
    if (currentDoorState == HIGH) {
      // the door is currently open
      if ((millis() - timerStartTime) > timerLength) {
        // the door has been open too long
        // play the song
        play_rtttl(song);
        // if the song is getting on your nerves, just play a tone for testing purposes:
        // speakerToner.play(NOTE_G3, 100);
        // if you're working in a quiet environment, test the script by blinking the LED instead of using the speaker:
        // blinkLED();
      }
    }
  }
}

/* FUNCTIONS */

// retrieve the current door state from the sensor
int getCurrentDoorState() {
  sensorBouncer.update();
  int currentDoorReading = sensorBouncer.read();
  return currentDoorReading;
}

// blink the LED at a pre-defined interval
void blinkLED() {
  ledCurrentTime = millis();
 
  if(ledCurrentTime - ledPreviousTime > ledBlinkInterval) {
    ledPreviousTime = ledCurrentTime;   
    if (ledState == LOW) {
      ledState = HIGH;
    }
    else {
      ledState = LOW;
    }
    digitalWrite(ledPin, ledState);
  }
}

// play an rtttl song
void play_rtttl(char *p)
{
  // Absolutely no error checking in here

  byte default_dur = 4;
  byte default_oct = 6;
  int bpm = 63;
  int num;
  long wholenote;
  long duration;
  byte note;
  byte scale;

  // format: d=N,o=N,b=NNN:
  // find the start (skip name, etc)

  while(*p != ':') p++;    // ignore name
  p++;                     // skip ':'

  // get default duration
  if(*p == 'd')
  {
    p++; p++;              // skip "d="
    num = 0;
    while(isdigit(*p))
    {
      num = (num * 10) + (*p++ - '0');
    }
    if(num > 0) default_dur = num;
    p++;                   // skip comma
  }

  Serial.print("ddur: "); Serial.println(default_dur, 10);

  // get default octave
  if(*p == 'o')
  {
    p++; p++;              // skip "o="
    num = *p++ - '0';
    if(num >= 3 && num <=7) default_oct = num;
    p++;                   // skip comma
  }

  Serial.print("doct: "); Serial.println(default_oct, 10);

  // get BPM
  if(*p == 'b')
  {
    p++; p++;              // skip "b="
    num = 0;
    while(isdigit(*p))
    {
      num = (num * 10) + (*p++ - '0');
    }
    bpm = num;
    p++;                   // skip colon
  }

  Serial.print("bpm: "); Serial.println(bpm, 10);

  // BPM usually expresses the number of quarter notes per minute
  wholenote = (60 * 1000L / bpm) * 4;  // this is the time for whole note (in milliseconds)

  Serial.print("wn: "); Serial.println(wholenote, 10);


  // now begin note loop
  while(*p)
  {
    // first, get note duration, if available
    num = 0;
    while(isdigit(*p))
    {
      num = (num * 10) + (*p++ - '0');
    }
    
    if(num) duration = wholenote / num;
    else duration = wholenote / default_dur;  // we will need to check if we are a dotted note after

    // now get the note
    note = 0;

    switch(*p)
    {
      case 'c':
        note = 1;
        break;
      case 'd':
        note = 3;
        break;
      case 'e':
        note = 5;
        break;
      case 'f':
        note = 6;
        break;
      case 'g':
        note = 8;
        break;
      case 'a':
        note = 10;
        break;
      case 'b':
        note = 12;
        break;
      case 'p':
      default:
        note = 0;
    }
    p++;

    // now, get optional '#' sharp
    if(*p == '#')
    {
      note++;
      p++;
    }

    // now, get optional '.' dotted note
    if(*p == '.')
    {
      duration += duration/2;
      p++;
    }
  
    // now, get scale
    if(isdigit(*p))
    {
      scale = *p - '0';
      p++;
    }
    else
    {
      scale = default_oct;
    }

    scale += OCTAVE_OFFSET;

    if(*p == ',')
      p++;       // skip comma for next note (or we may be at the end)

    // now play the note

    if(note)
    {
      speakerToner.play(notes[(scale - 4) * 12 + note]);
      delay(duration);
      speakerToner.stop();
    }
    else
    {
      delay(duration);
    }
  }
}

/* END PROGRAM */
