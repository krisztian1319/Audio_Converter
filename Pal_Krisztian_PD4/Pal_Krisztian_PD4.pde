import controlP5.*;
import beads.*;

import java.util.Timer;
import java.util.TimerTask;
import guru.ttslib.*;
import java.util.ArrayList;


//This is used to itterate the JSON list
JSONObject jsonInput;

AudioContext ac;
//This is creating the audio environment including the wave
Gain mainGain;
Glide mainGlide;
WavePlayer mainWave;

//These are used for creating the schedule that can be seen on the UI
ControlP5 p5;
String[] schedule = new String[10];
Textarea txt1, txt2, txt3, txt4, txt5, txt6, txt7, txt8, txt9, txt10, timeLeft, totalTimeDone;

//The arraylists to hold the JSON data
ArrayList<String> formFactor = new ArrayList<String>();
ArrayList<Integer> timeInData = new ArrayList<Integer>();
ArrayList<Integer> breathingLoudness = new ArrayList<Integer>();

//Text to speech module
TTS currentExercise;

  void setup() {
      size(700, 460);
      System.setProperty("freetts.voices", "com.sun.speech.freetts.en.us.cmu_us_kal.KevinVoiceDirectory");
      
      //Setting Up AC and wave
      ac = new AudioContext();
      mainGlide= new Glide(ac, .5, 500);
      mainGain = new Gain(ac, 1, mainGlide);
      
      
      
      mainWave = new WavePlayer(ac, 150f, Buffer.SINE);
      mainGain.addInput(mainWave);
      ac.out.pause(true);
      
      ac.out.addInput(mainGain);
      
      
      
      //This is structure for acessing specific JSON objects
      jsonInput = loadJSONObject("inputData.json");
      
      JSONArray inputArr = jsonInput.getJSONArray("breathingData");
      
      JSONObject inputObj;
      
     
      //This fills the arraylists with data from JSON file
      for(int i = 0; i < inputArr.size(); i++) {
        inputObj = inputArr.getJSONObject(i);
        formFactor.add(inputObj.getString("formFactor"));
        timeInData.add(inputObj.getInt("timeInSchedule"));
        breathingLoudness.add(inputObj.getInt("loudness"));
      }
      
      smooth();
      currentExercise = new TTS();
      
  
      // Below are all the buttons, sliders, and text boxes used for UI
      p5 = new ControlP5(this);
      
      p5.addTextfield("timerInput")
     .setPosition(450, 400)
     .setSize(50,20)
     .setAutoClear(true)
     .setLabel("TIMER INPUT (S)");
     
      p5.addButton("startSchedule")
     .setValue(0)
     .setSize(50, 20)
     .setPosition(520, 400)
     .setLabel("START");
     
      p5.addButton("lowForm")
     .setValue(0)
     .setSize(100, 40)
     .setPosition(80, 120)
     .setLabel("Low Form");
     
      p5.addButton("medForm")
     .setValue(0)
     .setSize(100, 40)
     .setPosition(80, 70)
     .setLabel("Medium Form");
     
      p5.addButton("highForm")
     .setValue(0)
     .setSize(100, 40)
     .setPosition(80, 20)
     .setLabel("High Form");
     
     p5.addButton("mute")
     .setSize(100, 40)
     .setPosition(80, 400)
     .setLabel("Mute");
     
     p5.addButton("freqOver")
     .setSize(100, 40)
     .setPosition(80, 170)
     .setLabel("Frequency Override");
     
      p5.addSlider("freqSlider")
     .setRange(150,250)
     .setValue(150)
     .setPosition(80, 250)
     .setSize(200, 40)
     .setLabel("Base Frequency");
     
      p5.addSlider("gainSlider")
     .setRange(0,1.5)
     .setValue(0)
     .setPosition(80, 300)
     .setSize(200, 40)
     .setLabel("Base Gain");
     
     p5.addSlider("dataFreqSlider")
     .setRange(1,10)
     .setValue(1)
     .setPosition(80, 350)
     .setSize(200, 40)
     .setLabel("Breathing Loudness Level (FREQ)");
     
      p5.addTextfield("listInput")
     .setPosition(450,10)
     .setSize(200,20)
     .setAutoClear(true)
     .setLabel("TYPE EXERCISES FOR LIST HERE");
     
      p5.addButton("addToList")
     .setValue(0)
     .setPosition(370, 10)
     .setLabel("INPUT");
     
     txt1 = p5.addTextarea("txt")
     .setPosition(450,80)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt1.setText("Exercise 1");
     
      txt2 = p5.addTextarea("txt2")
     .setPosition(450, 110)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt2.setText("Exercise 2");
     
      txt3 = p5.addTextarea("txt3")
     .setPosition(450,140)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt3.setText("Exercise 3");
     
      txt4 = p5.addTextarea("txt4")
     .setPosition(450,170)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt4.setText("Exercise 4");
     
      txt5 = p5.addTextarea("txt5")
     .setPosition(450,200)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt5.setText("Exercise 5");
     
      txt6 = p5.addTextarea("txt6")
     .setPosition(450,230)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt6.setText("Exercise 6");
     
      txt7 = p5.addTextarea("txt7")
     .setPosition(450,260)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt7.setText("Exercise 7");
     
      txt8 = p5.addTextarea("txt8")
     .setPosition(450,290)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt8.setText("Exercise 8");
     
      txt9 = p5.addTextarea("txt9")
     .setPosition(450,320)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt9.setText("Exercise 9");
     
      txt10 = p5.addTextarea("txt10")
     .setPosition(450,350)
     .setSize(200, 30)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     txt10.setText("Exercise 10");
     
     timeLeft = p5.addTextarea("timeLeft")
     .setPosition(350, 100)
     .setFont(createFont("arial", 20))
     .setLineHeight(14)
     .setColor(color(255));
     timeLeft.setText("0");
     
     totalTimeDone =  p5.addTextarea("totalTimeDone")
     .setPosition(333, 140)
     .setFont(createFont("arial", 12))
     .setLineHeight(14)
     .setColor(color(255));
     totalTimeDone.setText("Remaining Time");
     
     
     
     ac.start();
  }


  //This creates the background and other shapes that are needed
  void draw() {
    
    background(0); 
    fill(25, 99, 209);
    stroke(255);
    rect(450, 80, 200, 300);
    rect(347.5, 87.5, 60, 50);
    fill(255);
    for(int i = 110; i < 380; i+= 30) {
      rect(450, i, 200, 0.5);
    }

  }




// This function adds to list the exercises in order that are input into the text box
// Whenever the button is pused. This is used for TTS later. It also updates the visuals.
String inputText;
int schedulePosition = 0;

void addToList() {
 
  inputText = p5.get(Textfield.class, "listInput").getText();
  
   if (schedulePosition < 10) {
     schedule[schedulePosition] = inputText;
     p5.get(Textfield.class, "listInput").clear();
     
     if (schedulePosition == 0) {
       txt1.setText(inputText);
     }
     else if (schedulePosition == 1) {
       txt2.setText(inputText);
     }
      else if (schedulePosition == 2) {
       txt3.setText(inputText);
     }
      else if (schedulePosition == 3) {
       txt4.setText(inputText);
     }
      else if (schedulePosition == 4) {
       txt5.setText(inputText);
     }
      else if (schedulePosition == 5) {
       txt6.setText(inputText);
     }
      else if (schedulePosition == 6) {
       txt7.setText(inputText);
     }
      else if (schedulePosition == 7) {
       txt8.setText(inputText);
     }
      else if (schedulePosition == 8) {
       txt9.setText(inputText);
     }
      else if (schedulePosition == 9) {
       txt10.setText(inputText);
     }
    
     schedulePosition++;
   }
}




// This is the button that starts the timer and the timed function.
String inputTime;
int time;
int tempTime;
int timerPosition = 0;
Timer timer = new Timer();
int totalTime = 0;



void startSchedule() {
  if (schedulePosition != 0) {
    inputTime = p5.get(Textfield.class, "timerInput").getText();
    time = Integer.parseInt(inputTime);
    tempTime = time;
    timer.schedule(startScheduleRead, 0, 1000);
     
  }
}



// This is the timed function that takes in and interprets JSON data to alter and 
// dtermine the characteristics of the wave ugen which is sonified data on user breathing.
Boolean beginIteration = true;
float baseGain = 0;
float baseFreq = 150;
float changeFreq = 5;
float changeGain = 1;
Boolean waveOverride = false;

TimerTask startScheduleRead = new TimerTask() {
  @Override
  public void run() {

      for (int i = 0; i < timeInData.size(); i++) {
        if(timeInData.get(i) == totalTime) {
          
          if(!freqOverride) {
            changeFreq = breathingLoudness.get(i);
          }
          if (!waveOverride) {
            if(formFactor.get(i).equals("low")) { 
              changeGain = 0.33;
            }
            else if(formFactor.get(i).equals("med")) {
              changeGain = 0.66; 
            }
            else if (formFactor.get(i).equals("high")) {
     
              changeGain = 1; 
            }
          }
          i = timeInData.size();
          
        }
      }
      mainGain.setGain(baseGain + changeGain);
      mainWave.setFrequency(baseFreq + (changeFreq * 6));
    
    timeLeft.setText(Integer.toString(time));
    
    totalTime++;
    
    
    if(beginIteration) {
      beginIteration = false;
      time = tempTime;
      time--;
      ac.out.pause(true);
      currentExercise.speak(schedule[timerPosition]);
      
      
    }
    else {
      if(!muted) {
        ac.out.pause(false);
      }
      if (timerPosition == 0) {
         txt1.setColorBackground(255);
         txt1.setColor(#1963d1);
         
      }
      else if(timerPosition == 1) {
        txt2.setColorBackground(255); 
        txt1.disableColorBackground();
        txt1.setColor(255);
        txt2.setColor(#1963d1);
        
      }
      else if(timerPosition == 2) {
        txt3.setColorBackground(255); 
        txt2.disableColorBackground();
        txt2.setColor(255);
        txt3.setColor(#1963d1);
      }
      else if(timerPosition == 3) {
        txt4.setColorBackground(255); 
        txt3.disableColorBackground();
        txt3.setColor(255);
        txt4.setColor(#1963d1);
      }
      else if(timerPosition == 4) {
        txt5.setColorBackground(255); 
        txt4.disableColorBackground();
        txt4.setColor(255);
        txt5.setColor(#1963d1);
      }
      else if(timerPosition == 5) {
        txt6.setColorBackground(255); 
        txt5.disableColorBackground();
        txt5.setColor(255);
        txt6.setColor(#1963d1);
      }
      else if(timerPosition == 6) {
        txt7.setColorBackground(255); 
        txt6.disableColorBackground();
        txt6.setColor(255);
        txt7.setColor(#1963d1);
      }
      else if(timerPosition == 7) {
        txt8.setColorBackground(255); 
        txt7.disableColorBackground();
        txt7.setColor(255);
        txt8.setColor(#1963d1);
      }
      else if(timerPosition == 8) {
        txt9.setColorBackground(255); 
        txt8.disableColorBackground();
        txt8.setColor(255);
        txt9.setColor(#1963d1);
      }
      else if(timerPosition == 9) {
        txt10.setColorBackground(255); 
        txt9.disableColorBackground();
        txt9.setColor(255);
        txt10.setColor(#1963d1);
      }
      
      time--;
      if (time <= 0) {
        beginIteration = true;
        timerPosition++;
      }
    }
    if(timerPosition >= schedulePosition) {
        System.out.print("Done");
        currentExercise.speak("DONE");
        txt10.disableColorBackground();
        txt10.setColor(255);
        timer.cancel();
        ac.out.pause(true);
    }
  }
};


// These are the functions for the buttons that control the manual data input that controls the wave ugen.
Boolean lowPressed = false;
public void lowForm() {
  if (lowPressed == false) {
    waveOverride = true;
    mainGain.setGain(0.33);
    lowPressed = true;
  }
  else {
    waveOverride = false;
    lowPressed = false;
  }
  medPressed = false;
  highPressed = false;
}

Boolean medPressed = false;
public void medForm() {
  if (medPressed == false) {
    waveOverride = true;
    mainGain.setGain(0.66);
    medPressed = true;
  }
  else {
    waveOverride = false;
    medPressed = false;
  }
  lowPressed = false;
  highPressed = false;
}




Boolean highPressed = false;
public void highForm() {
  if (medPressed == false) {
    waveOverride = true;
    mainGain.setGain(1);
    highPressed = true;
  }
  else {
    waveOverride = false;
    highPressed = false;
  }
  medPressed = false;
  lowPressed = false;
}


// The next two sliders increase the base frequency and loudness. This does not affect the data.
void freqSlider(float value) {
  baseFreq = value;
 
}

void gainSlider(float value) {
  baseGain = value;
 
}


// This mutes the sound of the wave.
Boolean muted = false;
void mute() {
  if (!muted) {
    ac.out.pause(true);
    muted = true;
  }
  else {
   ac.out.pause(false); 
   muted = false;
  }
}


// This is to control the frequency data value which can be overridden to give the user 
// control on what value they want to output, for simulator purposes.
Boolean freqOverride = false;
void freqOver() {
 freqOverride = !freqOverride; 
}

void dataFreqSlider(float value) {
  if(freqOverride) {
    changeFreq = value;
  }
}
