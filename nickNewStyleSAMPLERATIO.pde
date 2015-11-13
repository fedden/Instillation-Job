// debug mode (no wait times)

boolean noWait = false;

//----------------- LIBRARY SHIZZLE ON MA NIZZLE ---------------------//

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//------------------- SOUND SHIZZLE ON MA NIZZLE ---------------------//

Minim minim; 
AudioPlayer [] sampPlayer; //extra sample of music etc..
AudioPlayer [] theDescriptionSample; //array of descriptions of types of characters
AudioPlayer button;

AudioPlayer [] horny0, horny1, moral0, moral1, passive0, passive1, pity0, pity1, poseur0, poseur1, troll0, troll1, whimsical0, whimsical1;

FFT fft;

BeatDetect beat;

//------------------------ CLASS SHIZZLE -----------------------------//

Timer connectingTimer, openingQuestionTimer, incomingMessageTimer, transitionTimer1, transitionTimer2, lockMenu; //various timers to time key events
Timer[] lerpTimers;

//character classes
Horny horny;
Moral moral;
Passive passive;
Pity pity;
Poseur poseur;
Troll troll;
Whimsical whimsical;

AnimatedText mrText;

LoadingGraphic mrLoad;
BetterTypeWriter betterTypeWriter;

RectButton menuBut1, menuBut2, menuBut3, menuBut4, menuBut5, menuBut6, menuBut7, sendBut, replyBut, returnBut, returnBut2, otherBut, playBut;

Spring fromLeft, fromTop, fromRight, fromBottom, fromCentre;

//----------------------- BOOLS AND COUNTERS -------------------------//

boolean coinFlip; //each character has two possible conversations and this helps choose combined with random()!
boolean inConversation = false; //am i talking?
boolean consecutive;
boolean userDisconnects;
boolean playOnce = true;
boolean moveThatAss, transitionTime;
boolean timerLock = false;

String user, computer, currentString;

int textHeight, alphaText = 255;
int state; //application state
int userConvNumber; //where are we in the conversation?
int compConvNumber;
int convScreenManager; //a state manager for displaying the various different screens within the conversation - similar to convNumber but completely different at the same time
int allowBothToSpeak; //counts to two, allows convNumber to increment once both user and computer have spoken
int stringLength, sampleLength;

//----------------------- SOME STYLISH SHIZZLE -----------------------//

PFont thinFont42, thinFont60, thinFont84, regularFont42, regularFont60, regularFont84, thickFont42, thickFont60, thickFont84; //no, its my font
color baseColor = color(102);
color currentcolor = baseColor;
color buttoncolor = color(204, 204, 204, 60);
color highlight = color(153, 153, 153, 60);
color invisible;
color blueCol = color(0, 0, 255);
color redCol = color(255, 0, 0);
color whiteCol = color(255);
color babyBlueCol = color(175, 202, 237);
color black;

static final String left = "left";
static final String right = "right";
static final String top = "top";
static final String bottom = "bottom";
//static final float scale = 50.0;

//----------------------- END OF DECLARATION -------------------------//


void setup() {
  size(displayWidth, displayHeight, P3D);

  textHeight = height/2 + round(0.2857142857*height);

  initButtons(); //initialise buttons
  initCharacterClasses(); //initialise characters

    mrLoad = new LoadingGraphic();
  mrText = new AnimatedText();
  betterTypeWriter = new BetterTypeWriter();

  if (!noWait) {
    connectingTimer = new Timer(10000);
    openingQuestionTimer = new Timer(8000);
    incomingMessageTimer = new Timer(3500);
    transitionTimer1 = new Timer(1000);
    transitionTimer2 = new Timer(2000);
    lerpTimers = new Timer[8];

    for (int i = 0; i < 7; i++) {
      lerpTimers[i] = new Timer(400);
    }
    lerpTimers[7] = new Timer(3000);
  } else {
    connectingTimer = new Timer(0);
    openingQuestionTimer = new Timer(0);
    incomingMessageTimer = new Timer(0);
    transitionTimer1 = new Timer(0);
    transitionTimer2 = new Timer(0);
    lerpTimers = new Timer[8];

    for (int i = 0; i < 7; i++) {
      lerpTimers[i] = new Timer(0);
    }
    lerpTimers[7] = new Timer(0);
  }
  lockMenu = new Timer(100);

  initSprings();

  smooth();
  stroke(0);
  thinFont42 = createFont("Quicksand-Light.otf", round(0.04*height));
  regularFont42 = createFont("Quicksand-Regular.otf", round(0.04*height));
  thickFont42 = createFont("Quicksand-Bold.otf", round(0.04*height));
  thinFont60 = createFont("Quicksand-Light.otf", round(0.05714285714*height));
  regularFont60 = createFont("Quicksand-Regular.otf", round(0.05714285714*height));
  thickFont60 = createFont("Quicksand-Bold.otf", round(0.05714285714*height));
  thinFont84 = createFont("Quicksand-Light.otf", round(0.08*height));
  regularFont84 = createFont("Quicksand-Regular.otf", round(0.08*height));
  thickFont84 = createFont("Quicksand-Bold.otf", round(0.08*height));
  textFont(thickFont60);
  textAlign(CENTER);
  state = 0;
  userConvNumber = 0;
  compConvNumber = 0;
  convScreenManager = 0;
  allowBothToSpeak = 0;
  inConversation = false;

  minim = new Minim(this);
  sampPlayer = new AudioPlayer[7];

  loadClassSamples();

  //init the description sample array
  theDescriptionSample = new AudioPlayer[7];

  //load description samples - long(ish) descriptions of the poser, the whimsical etc..
  loadDescriptionSamples();

  sampPlayer[0] = minim.loadFile("lightflare.mp3");
  sampPlayer[1] = minim.loadFile("final.mix.1.mp3");
  sampPlayer[2] = minim.loadFile("martinerose(mix1).mp3");
}

void draw() {
  background(255);
  chooseState();
  stateManager();
}

/////////////////////////////////////////////////////////////////
//  state manager runs the appropriate functions depending on  //
//  the character the user selected using the chooseState      //
//  function (depending on which menu button they pressed!)    //
/////////////////////////////////////////////////////////////////

void stateManager() {
  if (state == 0) { //in the beginning god made state == 0
    for (int i = 0; i < theDescriptionSample.length; i++) {   
      theDescriptionSample[i].rewind();
      theDescriptionSample[i].pause();
    }
    timedMenuButtonsLock();
    displayMenuButtons(); //display all menu buttons
  } else if (state == 1) { //user is feeling horny

    if (coinFlip) { //check recently randomised boolean
      //run horny and troll branch
      hornyAndTrollBranch(0); //sends argument of zero to set user to play as horny, not troll
    } else {
      //run horny and whimsical branch
      hornyAndWhimsicalBranch(0);
    }
  } else if (state == 2) { //user is feeling moral

    if (coinFlip) { //check recently randomised boolean
      //run moral and whimsical branch
      moralAndWhimsicalBranch(0); //sends argument of zero to set user to play as moral, not whimsical
    } else {
      //run moral and pity branch
      moralAndPityBranch(0);
    }
  } else if (state == 3) { //user is feeling passive 

    if (coinFlip) { //check recently randomised boolean
      //run passive and pity branch
      passiveAndPityBranch(0); //sends argument of zero to set user to play as moral, not whimsical
    } else {
      //run passive and poseur branch
      passiveAndPoseurBranch(0);
    }
  } else if (state == 4) { //user is feeling pitiful (of this crappy code)

    if (coinFlip) { //check recently randomised boolean
      //run passive and pity
      passiveAndPityBranch(1); //sends argument of one to set user to play as pity, not passive
    } else {
      //run moral and pity branch
      moralAndPityBranch(1);
    }
  } else if (state == 5) { //user is feeling like a show off

    if (coinFlip) { //check recently randomised boolean
      //run passive and poseur branch
      passiveAndPoseurBranch(1);
    } else {
      //run troll and poseur branch
      trollAndPoseurBranch(1);
    }
  } else if (state == 6) { //user is feeling like a whimsical

    if (coinFlip) { //check recently randomised boolean
      //run moral and whimsical branch
      moralAndWhimsicalBranch(1);
    } else {
      //run horny and whimsical
      hornyAndWhimsicalBranch(1);
    }
  } else if (state == 7) { //the user looks like a troll

    if (coinFlip) { //check recently randomised boolean
      //run moral and whimsical branch
      trollAndPoseurBranch(0); //sends argument of zero to set user to play as moral, not whimsical
    } else {
      //run moral and pity branch
      hornyAndTrollBranch(1);
    }
  }
}

/////////////////////////////////////////////////////////////////
//  App state is managed in chooseState by pressing buttons    //
//  Each time state transitions from 0 --> 1-7 note that the   //
//  coinFlip function is called which randomly sets the        //
//  coinFlip boolean to true or false. We do that to select    //
//  out of the two conversation options for each character!    //
/////////////////////////////////////////////////////////////////

void chooseState() {
  if (mousePressed) { 

    if (menuBut1.overRect(menuBut1.x, menuBut1.y, round(width*0.29761904761905), round(height*0.09523809524)) && state == 0) {


      coinFlip(); //flip a coin/boolean to decide which convo branch is selected before changing state
      state = 1;
    } else if (menuBut2.overRect(menuBut2.x, menuBut2.y, round(width*0.29761904761905), round(height*0.09523809524)) && state == 0) {


      coinFlip(); //flip a coin/boolean to decide which convo branch is selected before changing state
      state = 2;
    } else if (menuBut3.overRect(menuBut3.x, menuBut3.y, round(width*0.29761904761905), round(height*0.09523809524)) && state == 0) {


      coinFlip(); //flip a coin/boolean to decide which convo branch is selected before changing state
      state = 3;
    } else if (menuBut4.overRect(menuBut4.x, menuBut4.y, round(width*0.29761904761905), round(height*0.09523809524)) && state == 0) {


      coinFlip(); //flip a coin/boolean to decide which convo branch is selected before changing state
      state = 4;
    } else if (menuBut5.overRect(menuBut5.x, menuBut5.y, round(width*0.29761904761905), round(height*0.09523809524)) && state == 0) {


      coinFlip(); //flip a coin/boolean to decide which convo branch is selected before changing state
      state = 5;
    } else if (menuBut6.overRect(menuBut6.x, menuBut6.y, round(width*0.29761904761905), round(height*0.09523809524)) && state == 0) {


      coinFlip(); //flip a coin/boolean to decide which convo branch is selected before changing state
      state = 6;
    } else if (menuBut7.overRect(menuBut7.x, menuBut7.y, round(width*0.29761904761905), round(height*0.09523809524)) && state == 0) {


      coinFlip(); //flip a coin/boolean to decide which convo branch is selected before changing state
      state = 7;
    }
  }
}

/////////////////////////////////////////////////////////////////
//  When transitioning from state 0 --> 1-7 a random descision //
//  needs to be made to decide out of the two convo partners   //
/////////////////////////////////////////////////////////////////

void coinFlip() {
  if (random(1.0) < 0.5) { //if random(0-1) is less than 0.5
    coinFlip = false;
  } else {
    coinFlip = true;
  }
}


/////////////////////////////////////////////////////////////////
//  any conversation between horny and troll is managed here,  //
//  the user can be either the horny or the troll via the only //
//  avaiblale argument. If inConversation bool is false then   //
//  the user's choice of character will be described           //
/////////////////////////////////////////////////////////////////

void hornyAndTrollBranch(int _whatCharacter) {
  //if function argument is 0 - user == horny, else if argument == 1 - user is troll
  if (_whatCharacter == 0) {

    if (!inConversation) {
      theDescription(0); //displays description of the horny
      theDescriptionSample[0].play(); //plays sample description of the horny
    } else {
      theDescriptionSample[0].pause();
      theDescriptionSample[0].rewind();
      //user is horny and is having a chat
      conversation(0, 6);
    }
  } else {

    if (!inConversation) {
      theDescription(6); //displays description of the troll
      theDescriptionSample[6].play(); //plays sample description of the troll
    } else {
      theDescriptionSample[6].pause();
      theDescriptionSample[6].rewind();
      //user is troll and is having a chat
      conversation(6, 0);
    }
  }
}

/////////////////////////////////////////////////////////////////
//  any conversation between horny and whimsical is managed    //
//  here. the user can be either the horny or the whim. via    //
//  the only avaiblale argument. If inConversation bool is     //
//  false then the user's choice of character will be described//
/////////////////////////////////////////////////////////////////

void hornyAndWhimsicalBranch(int _whatCharacter) {
  //if function argument is 0 - user == horny, else if argument == 1 - user is whimsical
  if (_whatCharacter == 0) {

    if (!inConversation) {
      theDescription(0); //displays description of the horny
      theDescriptionSample[0].play(); //plays sample description of the horny
    } else {
      theDescriptionSample[0].pause();
      theDescriptionSample[0].rewind();
      //user is horny and is having a chat
      conversation(0, 5);
    }
  } else {

    if (!inConversation) {
      theDescription(5); //displays description of the whimsical
      theDescriptionSample[5].play();
    } else {
      theDescriptionSample[5].pause();
      theDescriptionSample[5].rewind();
      //user is whimsical and is having a chat
      conversation(5, 0);
    }
  }
}

/////////////////////////////////////////////////////////////////
//  any conversation between moral and whimsical is managed    //
//  here. the user can be either the moral or the whim. via    //
//  the only avaiblale argument. If inConversation bool is     //
//  false then the user's choice of character will be described//
/////////////////////////////////////////////////////////////////

void moralAndWhimsicalBranch(int _whatCharacter) {
  //if function argument is 0 - user == moral, else if argument == 1 - user is whimsical
  if (_whatCharacter == 0) {

    if (!inConversation) {
      theDescription(1); //displays description of the moral
      theDescriptionSample[1].play(); //plays sample description of the moral
    } else {
      theDescriptionSample[1].pause();
      theDescriptionSample[1].rewind();
      //user is moral and is having a chat
      conversation(1, 5);
    }
  } else {

    if (!inConversation) {
      theDescription(5); //displays description of the whimsical
      theDescriptionSample[5].play();
    } else {
      theDescriptionSample[5].pause();
      theDescriptionSample[5].rewind();
      //user is whimsical and is having a chat
      conversation(5, 1);
    }
  }
}

/////////////////////////////////////////////////////////////////
//  any conversation between moral and pity is managed         //
//  here. the user can be either the moral or pitiful   via    //
//  the only avaiblale argument. If inConversation bool is     //
//  false then the user's choice of character will be described//
/////////////////////////////////////////////////////////////////

void moralAndPityBranch(int _whatCharacter) {
  //if function argument is 0 - user == moral, else if argument == 1 - user is pitiful
  if (_whatCharacter == 0) {

    if (!inConversation) {
      theDescription(1); //displays description of the moral
      theDescriptionSample[1].play(); //plays sample description of the moral
    } else {
      theDescriptionSample[1].pause();
      theDescriptionSample[1].rewind();
      //user is moral and is having a chat
      conversation(1, 3);
    }
  } else {

    if (!inConversation) {
      theDescription(3); //displays description of the pity
      theDescriptionSample[3].play();
    } else {
      theDescriptionSample[3].pause();
      theDescriptionSample[3].rewind();
      //user is pitiful and is having a chat
      conversation(3, 1);
    }
  }
}


PVector transition(String mode, float _destinationx, float _destinationy) {
  if (mode == "left") {
    return fromLeft.horizontalSpring(_destinationx, _destinationy);
  } else if (mode == "right") {
    return fromRight.horizontalSpring(_destinationx, _destinationy);
  } else if (mode == "top") {
    return fromTop.verticalSpring(_destinationx, _destinationy);
  } else if (mode == "bottom") {
    return fromBottom.verticalSpring(_destinationx, _destinationy);
  } else {
    return null;
  }
}

/////////////////////////////////////////////////////////////////
//  any conversation between passive and pity is managed       //
//  here. the user can be either passive   or pitiful   via    //
//  the only avaiblale argument. If inConversation bool is     //
//  false then the user's choice of character will be described//
/////////////////////////////////////////////////////////////////

void passiveAndPityBranch(int _whatCharacter) {
  //if function argument is 0 - user == passive, else if argument == 1 - user is pitiful
  if (_whatCharacter == 0) {

    if (!inConversation) {
      theDescription(2); //displays description of the passive
      theDescriptionSample[2].play(); //plays sample description of the passive
    } else {
      theDescriptionSample[2].pause();
      theDescriptionSample[2].rewind();
      //user is passive and is having a chat
      conversation(2, 3);
    }
  } else {

    if (!inConversation) {
      theDescription(3); //displays description of the pity
      theDescriptionSample[3].play();
    } else {
      theDescriptionSample[3].pause();
      theDescriptionSample[3].rewind();
      //user is pitiful and is having a chat
      conversation(3, 2);
    }
  }
}

/////////////////////////////////////////////////////////////////
//  any conversation between passive and poseur is managed     //
//  here. the user can be either passive   or pitiful   via    //
//  the only avaiblale argument. If inConversation bool is     //
//  false then the user's choice of character will be described//
/////////////////////////////////////////////////////////////////

void passiveAndPoseurBranch(int _whatCharacter) {
  //if function argument is 0 - user == passive, else if argument == 1 - user is poseur
  if (_whatCharacter == 0) {

    if (!inConversation) {
      theDescription(2); //displays description of the passive
      theDescriptionSample[2].play(); //plays sample description of the passive
    } else {
      theDescriptionSample[2].pause();
      theDescriptionSample[2].rewind();
      //user is passive and is having a chat
      conversation(2, 4);
    }
  } else {

    if (!inConversation) {
      theDescription(4); //displays description of the poseur
      theDescriptionSample[4].play();
    } else {
      theDescriptionSample[4].pause();
      theDescriptionSample[4].rewind();
      //user is pitiful and is having a chat
      conversation(4, 2);
    }
  }
}

/////////////////////////////////////////////////////////////////
//  any conversation between troll and poseur is managed       //
//  here. the user can be either troll or poseur via the only  //
//  avaiblale argument. If inConversation bool is false then   //
//  the user's choice of character will be described           //
/////////////////////////////////////////////////////////////////

void trollAndPoseurBranch(int _whatCharacter) {
  //if function argument is 0 - user == troll, else if argument == 1 - user is poseur
  if (_whatCharacter == 0) {

    if (!inConversation) {
      theDescription(6); //displays description of the troll
      theDescriptionSample[6].play(); //plays sample description of the troll
    } else {
      theDescriptionSample[6].pause();
      theDescriptionSample[6].rewind();
      //user is troll and is having a chat
      conversation(6, 4);
    }
  } else {

    if (!inConversation) {
      theDescription(4); //displays description of the poseur
      theDescriptionSample[4].play();
    } else {
      theDescriptionSample[4].pause();
      theDescriptionSample[4].rewind();
      //user is pitiful and is having a chat
      conversation(4, 6);
    }
  }
}


/////////////////////////////////////////////////////////////////
//  used for displaying the description of each type of        //
//  character - the horny, the whimsical, the troll etc before //
//  the conversation begins - it takes one int arg. that is    //
//  used as the switch expression                              //
/////////////////////////////////////////////////////////////////

void theDescription(int _state) {
  if (playBut.pressed() && mousePressed) {
    println("play button pressed in func() theDescription");
    connectingTimer.start();
    inConversation = true;
  }
  //  } else if (returnBut2.pressed()) {
  //    println("return2 button pressed in func() theDescription");
  //    initSprings();
  //    currentcolor = returnBut2.basecolor;
  //    state = 0;
  //  }
  //display play this character button
  background(255);
  textFont(regularFont42);

  PVector playButtonPosition = transition(bottom, 5*width/6, height-round(height*0.09523809524));
  playBut.x = (int)playButtonPosition.x - round(width*0.00416666666667);
  playBut.y = (int)playButtonPosition.y;
  playBut.display();
  fill(0);
  text("Play This Character", playBut.x, playBut.y + round(height*0.01904761905));

  //display return to the main menu (state == 0) button
  PVector returnButton2Position = transition(bottom, width/6, height-round(height*0.09523809524));
  returnBut2.x = (int)returnButton2Position.x + round(width*0.00416666666667);
  returnBut2.y = (int)returnButton2Position.y;
  returnBut2.display();
  fill(0);
  text("Choose Again", returnBut2.x, returnBut2.y + round(height*0.01904761905));

  textAlign(CENTER);
  fill(0);
  textFont(regularFont84);
  switch (_state) {

    //the horny
  case 0:
    text("The Horny", width/2, round(height*0.1571428571));
    textFont(regularFont42);
    text("The Horny wants to talk dirty. They will disconnect all males. Their conversation is based on trying to figure out if the stranger is female. They will ask ASL? (Age, Sex, Location) Until they get an answer. If the stranger is or claims to be female the Horny will feign interest in the topics of conversation and humor them but will ultimately try to get down to dirty talk as soon as possible.", width/2, height/2 + round(height*0.1571428571), width-300, height-round(height*0.380952391));
    break;

    //the moral
  case 1:
    text("The Moral", width/2, round(height*0.1571428571));
    textFont(regularFont42);
    text("This character is comparable to a white male who wants women and minorities to love them out of guilt of their own privilege, a White Knight if you will. They claim to have no time for bullshitters and bigots but will spend a considerable amount of time effort lecturing them on why they are wrong. They don’t consider themselves perfect but do consider themselves above most. They feed the trolls, try and help the pity party, make the whimsical political, humble (or humiliate) the show off and will try to influence the passive. They upkeep and defend political correctness most fiercely.", width/2, height/2 + round(height*0.0619047619), width-300, height-round(height*0.380952391));
    break;

    //the passive
  case 2:
    text("The Passive", width/2, round(height*0.1571428571));
    textFont(regularFont42);
    text("The point of the passive is to listen or enable another character. This is done by asking questions, playing along with games or just being background feedback for rants. When a conversation is cooperative then it is only about banal things such as food, General Knowledge, traffic e.c.t. They avoid talking about themselves and act as an observer in a conversation rather than an active participate in one. The likelihood is that they are half watching a film while having this conversation.", width/2, height/2 + round(height*0.0619047619), width-300, height-round(height*0.380952391));
    break;

    //the pitiful
  case 3:
    text("The Pitiful", width/2, round(height*0.1571428571));
    textFont(regularFont42);
    text("The Pitiful is a character that will always try and make the conversation about them. They possibly come here as no one else listens to them. They are always either; ill, in pain, sleep deprived, depressed and/or lonely. They don’t want help or suggestions on how to make things better. They just want people to pity them.", width/2, height/2 + round(height*0.1571428571), width-300, height-round(height*0.380952391));
    break;

    //the show off
  case 4:
    text("The Poseur", width/2, round(height*0.1571428571));
    textFont(regularFont42);
    text("This person will dominate the conversation. The Poseur is delusional about their self worth and feels unappreciated in the real world. They are philosophical but not informed by philosophy, they claim to have a black belt in some martial art but maybe only took one class, They claim to be popular yet a lone wolf and will brag about taking recreational drugs most casually from a scientific perspective. They are intelligent but their intellect belongs to the same branch of pseudo intelligence that Will Smith’s children display. All their information comes from the first paragraph of a Wikipedia article. They believe they are better than everyone else here.", width/2, height/2 + round(height*0.0619047619), width-300, height-round(height*0.380952391));
    break;

    //the whimsical
  case 5:
    text("The Whimsical", width/2, round(height*0.1571428571));
    textFont(regularFont42);
    text("This person is here for play. Similar to the troll they will not engage with a co-operative conversation but will pick up on words and take them out of context to change subject to everything and nothing at once. They do not converse but play. This is a game of language or role-play or both at the same time. While they use similar techniques to The Troll their aim is to make people smile or laugh at their kawaii antics.", width/2, height/2 + round(height*0.1571428571), width-300, height-round(height*0.380952391));
    break;

    //the troll
  case 6:
    text("The Troll", width/2, round(height*0.1571428571));
    textFont(regularFont42);
    text("The Troll feeds on reactions and will say just about anything to get a rise out of people. Nothing is considered taboo. They ignore the content of the stranger’s utterances but will pick up on themes in their attempt to aggravate; showing that they are reading the discourse but choosing to ignore it’s value. The Troll sometimes will play a longer game of role-play to evoke an even bigger reaction out of the stranger. However they quickly become disinterested when people do not play into their hands and will disconnect swiftly.", width/2, height/2 + round(height*0.0619047619), width-300, height-round(height*0.380952391));
    break;
  }
}

/////////////////////////////////////////////////////////////////
// here we load character descriptive samples called in setup()//
/////////////////////////////////////////////////////////////////

void loadDescriptionSamples() {
  theDescriptionSample[0] = minim.loadFile("TheHorny.mp3");
  theDescriptionSample[1] = minim.loadFile("TheMoral.mp3");
  theDescriptionSample[2] = minim.loadFile("ThePassive.mp3");
  theDescriptionSample[3] = minim.loadFile("ThePitiful.mp3");
  theDescriptionSample[4] = minim.loadFile("TheShowOff.mp3");
  theDescriptionSample[5] = minim.loadFile("TheWhimsical.mp3");
  theDescriptionSample[6] = minim.loadFile("TheTroll.mp3");
}

//change the colour here
color lerpColour(color basecolor, color highlightcolor, int _x, int _y, int _width, int _height, int timer) {
  int base_red = int(red(basecolor));
  int base_green = int(green(basecolor));
  int base_blue = int(blue(basecolor));
  int high_red  = int(red(highlightcolor));
  int high_green  = int(green(highlightcolor));
  int high_blue  = int(blue(highlightcolor));
  int base_alpha = int(alpha(basecolor));
  int high_alpha = int(alpha(highlightcolor));

  if (mouseX >= _x - _width/2 && mouseX <= _x+_width/2 && mouseY >= _y  - _height/2 && mouseY <= _y+_height/2) {
    if (!lerpTimers[timer].isFinished()) {
      float current_red = lerpTimers[timer].timedLerp(base_red, high_red);
      float current_green = lerpTimers[timer].timedLerp(base_green, high_green);
      float current_blue = lerpTimers[timer].timedLerp(base_blue, high_blue);
      float current_alpha = lerpTimers[timer].timedLerp(base_alpha, high_alpha);
      return color(current_red, current_green, current_blue, current_alpha);
    } else { 
      return highlightcolor;
    }
  } else {
    lerpTimers[timer].start();
    return basecolor;
  }
}

/////////////////////////////////////////////////////////////////
//  when state == 0 in stateManager, this function is called.  //
//  it displays circle buttons with the appropriate characters //
/////////////////////////////////////////////////////////////////

void displayMenuButtons() {

  fill(0);
  textAlign(CENTER);
  textFont(regularFont84);
  text("Choose a character:", width/2, round(height*0.1571428571));
  textFont(thinFont60);
  fill(invisible);
  noStroke();
  int ballSize = round(height*0.007619047619);
  int spacing = round(width*0.01071428571);

  menuBut1.display();
  PVector menu1 = transition(left, menuBut1.x, menuBut1.y + round(height*0.01428571429));
  String horny = "The Horny";
  float hornyWidth = textWidth(horny);
  color black = color(0);
  color red = color(255, 0, 0);
  fill(color(lerpColour(black, red, int(menu1.x), int(menu1.y), round(width*0.29761904761905), round(height*0.09523809524), 0)));
  if (menuBut1.overRect(int(menu1.x), int(menu1.y), round(width*0.29761904761905), round(height*0.09523809524))) {
    ellipse(menu1.x - spacing - hornyWidth/2, menu1.y - round(height*0.0047619047619), ballSize, ballSize);
    ellipse(menu1.x + spacing + hornyWidth/2, menu1.y - round(height*0.0047619047619), ballSize, ballSize);
  }
  text(horny, menu1.x, menu1.y + round(height*0.01428571429), round(width*0.29761904761905), round(height*0.09523809524));
  fill(invisible);

  menuBut2.display();
  PVector menu2 = transition(left, menuBut2.x, menuBut2.y + round(height*0.01428571429));
  String moral = "The Moral";
  float moralWidth = textWidth(moral);
  fill(color(lerpColour(black, red, int(menu2.x), int(menu2.y), round(width*0.29761904761905), round(height*0.09523809524), 1)));
  if (menuBut2.overRect(int(menu2.x), int(menu2.y), round(width*0.29761904761905), round(height*0.09523809524))) {
    ellipse(menu2.x - spacing - moralWidth/2, menu2.y - round(height*0.0047619047619), ballSize, ballSize);
    ellipse(menu2.x + spacing + moralWidth/2, menu2.y - round(height*0.0047619047619), ballSize, ballSize);
  }
  text(moral, menu2.x, menu2.y + round(height*0.01428571429), round(width*0.29761904761905), round(height*0.09523809524));
  fill(invisible);

  menuBut3.display();
  PVector menu3 = transition(right, menuBut3.x, menuBut3.y + round(height*0.01428571429));
  String passive = "The Passive";
  float passiveWidth = textWidth(passive);
  fill(color(lerpColour(black, red, int(menu3.x), int(menu3.y), round(width*0.29761904761905), round(height*0.09523809524), 2)));
  if (menuBut3.overRect(int(menu3.x), int(menu3.y), round(width*0.29761904761905), round(height*0.09523809524))) {
    ellipse(menu3.x - spacing - passiveWidth/2, menu3.y - round(height*0.0047619047619), ballSize, ballSize);
    ellipse(menu3.x + spacing + passiveWidth/2, menu3.y - round(height*0.0047619047619), ballSize, ballSize);
  }
  text(passive, menu3.x, menu3.y + round(height*0.01428571429), round(width*0.29761904761905), round(height*0.09523809524));
  fill(invisible);

  menuBut4.display();
  PVector menu4 = transition(left, menuBut4.x, menuBut4.y + round(height*0.01428571429));
  String pity = "The Pitiful";
  float pityWidth = textWidth(pity);
  fill(color(lerpColour(black, red, int(menu4.x), int(menu4.y), round(width*0.29761904761905), round(height*0.09523809524), 3)));
  if (menuBut4.overRect(int(menu4.x), int(menu4.y), round(width*0.29761904761905), round(height*0.09523809524))) {
    ellipse(menu4.x - spacing - pityWidth/2, menu4.y - round(height*0.0047619047619), ballSize, ballSize);
    ellipse(menu4.x + spacing + pityWidth/2, menu4.y - round(height*0.0047619047619), ballSize, ballSize);
  }
  text(pity, menu4.x, menu4.y + round(height*0.01428571429), round(width*0.29761904761905), round(height*0.09523809524));
  fill(invisible);

  menuBut5.display();
  PVector menu5 = transition(right, menuBut5.x, menuBut5.y + round(width*0.01428571429));
  String poseur = "The Poseur";
  float poseurWidth = textWidth(poseur);
  fill(color(lerpColour(black, red, int(menu5.x), int(menu5.y), round(height*0.29761904761905), round(height*0.09523809524), 4)));
  if (menuBut5.overRect(int(menu5.x), int(menu5.y), round(width*0.29761904761905), round(height*0.09523809524))) {
    ellipse(menu5.x - spacing - poseurWidth/2, menu5.y - round(height*0.0047619047619), ballSize, ballSize);
    ellipse(menu5.x + spacing + poseurWidth/2, menu5.y - round(height*0.0047619047619), ballSize, ballSize);
  }
  text(poseur, menu5.x, menu5.y + round(height*0.01428571429), round(width*0.29761904761905), round(height*0.09523809524));
  fill(invisible);

  menuBut6.display();
  PVector menu6 = transition(left, menuBut6.x, menuBut6.y + round(height*0.01428571429));
  String whimsical = "The Whimsical";
  float whimsicalWidth = textWidth(whimsical);
  fill(color(lerpColour(black, red, int(menu6.x), int(menu6.y), round(width*0.29761904761905), round(height*0.09523809524), 5)));
  if (menuBut6.overRect(int(menu6.x), int(menu6.y), round(width*0.29761904761905), round(height*0.09523809524))) {
    ellipse(menu6.x - spacing - whimsicalWidth/2, menu6.y - round(height*0.0047619047619), ballSize, ballSize);
    ellipse(menu6.x + spacing + whimsicalWidth/2, menu6.y - round(height*0.0047619047619), ballSize, ballSize);
  }
  text(whimsical, menu6.x, menu6.y + round(height*0.01428571429), round(width*0.29761904761905), round(height*0.09523809524));
  fill(invisible);

  menuBut7.display();
  PVector menu7 = transition(right, menuBut7.x, menuBut7.y + round(height*0.01428571429));
  String troll = "The Troll";
  float trollWidth = textWidth(troll);
  fill(color(lerpColour(black, red, int(menu7.x), int(menu7.y), round(width*0.29761904761905), round(height*0.09523809524), 6)));
  if (menuBut7.overRect(int(menu7.x), int(menu7.y), round(width*0.29761904761905), round(height*0.09523809524))) {
    ellipse(menu7.x - spacing - trollWidth/2, menu7.y - round(height*0.0047619047619), ballSize, ballSize);
    ellipse(menu7.x + spacing + trollWidth/2, menu7.y - round(height*0.0047619047619), ballSize, ballSize);
  }
  text(troll, menu7.x, menu7.y + round(height*0.01428571429), round(width*0.29761904761905), round(height*0.09523809524));
  fill(invisible);
}

void conversation(int _userCharacter, int _computerCharacter) {

  //the arguments run from 0 - 6
  //0 - horny
  //1 - moral
  //2 - passive
  //3 - pitiful
  //4 - showoff
  //5 - whimsical
  //6 - troll

  //we pair up the characters for the conversation and call conversation display with the correct arguments
  //args == (String _user, String[] _userString, AudioPlayer[] _computerSample, String _openingQuestion, boolean _userIsStarting)
  if ((_userCharacter == 0) && (_computerCharacter == 6)) {

    //user: horny    
    //computer: troll
    conversationDisplay("Horny", "Troll", horny.chat0, troll1, "16m looking for F16-25 Kik me at √∑^µå…ø∆", true, true);
  } else if ((_userCharacter == 6) && (_computerCharacter == 0)) {

    //user: troll    
    //computer: horny
    conversationDisplay("Troll", "Horny", troll.chat1, horny0, "16m looking for F16-25 Kik me at √∑^µå…ø∆", false, false);
  } else if ((_userCharacter == 0) && (_computerCharacter == 5)) {

    //user: horny    
    //computer: whimsical
    conversationDisplay("Horny", "Whimsical", horny.chat1, whimsical0, "What should you be doing right now?", true, true);
  } else if ((_userCharacter == 5) && (_computerCharacter == 0)) {

    //user: whimsical   
    //computer: horny
    conversationDisplay("Whimsical", "Horny", whimsical.chat0, horny1, "What should you be doing right now?", false, false);
  } else if ((_userCharacter == 1) && (_computerCharacter == 3)) {

    //user: moral    
    //computer: pity
    conversationDisplay("Moral", "Pitiful", moral.chat0, pity0, "What did you expect from this?", false, false);
  } else if ((_userCharacter == 3) && (_computerCharacter == 1)) {

    //user: pity   
    //computer: moral
    conversationDisplay("Pitiful", "Moral", pity.chat0, moral0, "What did you expect from this?", true, true);
  } else if ((_userCharacter == 1) && (_computerCharacter == 5)) {

    //user: moral
    //computer: whimsical
    conversationDisplay("Moral", "Whimsical", moral.chat1, whimsical1, "Have you ever tried wanking with your left hand? If so how difficult was it?", false, true);
  } else if ((_userCharacter == 5) && (_computerCharacter == 1)) {

    //user: whimsical
    //computer: moral
    conversationDisplay("Whimsical", "Moral", whimsical.chat1, moral1, "Have you ever tried wanking with your left hand? If so how difficult was it?", true, false);
  } else if ((_userCharacter == 2) && (_computerCharacter == 4)) {

    //user: passive
    //computer: poseur
    conversationDisplay("Passive", "Poseur", passive.chat1, poseur0, "What should you be doing right now?", false, false);
  } else if ((_userCharacter == 4) && (_computerCharacter == 2)) {

    //user: poseur
    //computer: passive
    conversationDisplay("Poseur", "Passive", poseur.chat0, passive1, "What should you be doing right now?", true, true);
  } else if ((_userCharacter == 2) && (_computerCharacter == 3)) {

    //user: passive
    //computer: pity
    conversationDisplay("Passive", "Pitiful", passive.chat0, pity1, "Why are you here?", true, true);
  } else if ((_userCharacter == 3) && (_computerCharacter == 2)) {

    //user: pity
    //computer: passive
    conversationDisplay("Pitiful", "Passive", pity.chat1, passive0, "Why are you here?", false, false);
  } else if ((_userCharacter == 4) && (_computerCharacter == 6)) {

    //user: poseur
    //computer: troll
    conversationDisplay("Poseur", "Troll", poseur.chat1, troll0, "What do you do in your spare time?", false, false);
  } else if ((_userCharacter == 6) && (_computerCharacter == 4)) {

    //user: troll
    //computer: poseur
    conversationDisplay("Troll", "Poseur", troll.chat0, poseur1, "What do you do in your spare time?", true, true);
  }
}

boolean consecutiveSample(String _userCharacter, String _computerCharacter, int _convNumber) {

  if ((_userCharacter == "Horny") && (_computerCharacter == "Troll")) {
    if (_convNumber == 0) {
      return true;
    } else if (_convNumber == 17) {
      return true;
    } else if (_convNumber == 18) {
      return true;
    } else  if (_convNumber == 20) {
      return true;
    } else  if (_convNumber == 22) {
      return true;
    } else  if (_convNumber == 26) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Troll") && (_computerCharacter == "Horny")) {
    if (_convNumber == 10) {
      return true;
    } else  if (_convNumber == 24) {
      return true;
    } else  if (_convNumber == 26) {
      return true;
    } else  if (_convNumber == 27) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Horny") && (_computerCharacter == "Whimsical")) {
    return false;
  } else if ((_userCharacter == "Whimsical") && (_computerCharacter == "Horny")) {
    if (_convNumber == 13) {
      return true;
    } else  if (_convNumber == 14) {
      return true;
    } else  if (_convNumber == 15) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Moral") && (_computerCharacter == "Pitiful")) {
    if (_convNumber == 6) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Pitiful") && (_computerCharacter == "Moral")) {
    return false;
  } else if ((_userCharacter == "Moral") && (_computerCharacter == "Whimsical")) {
    if (_convNumber == 3) {
      return true;
    } else if (_convNumber == 4) {
      return true;
    } else if (_convNumber == 6) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Whimsical") && (_computerCharacter == "Moral")) {
    if (_convNumber == 2) {
      return true;
    } else if (_convNumber == 6) {
      return true;
    } else if (_convNumber == 7) {
      return true;
    } else if (_convNumber == 8) {
      return true;
    } else if (_convNumber == 11) {
      return true;
    } else if (_convNumber == 12) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Passive") && (_computerCharacter == "Poseur")) {
    if (_convNumber == 8) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Poseur") && (_computerCharacter == "Passive")) {
    if (_convNumber == 2) {
      return true;
    } else if (_convNumber == 3) {
      return true;
    } else if (_convNumber == 4) {
      return true;
    } else if (_convNumber == 10) {
      return true;
    } else if (_convNumber == 20) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Passive") && (_computerCharacter == "Pitiful")) {
    if (_convNumber == 4) {
      return true;
    } else if (_convNumber == 6) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Pitiful") && (_computerCharacter == "Passive")) {
    return false;
  } else if ((_userCharacter == "Poseur") && (_computerCharacter == "Troll")) {
    if (_convNumber == 4) {
      return true;
    } else  if (_convNumber == 5) { 
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Troll") && (_computerCharacter == "Poseur")) {
    if (_convNumber == 5) {
      return true;
    } else if (_convNumber == 6) {
      return true;
    } else if (_convNumber == 14) {
      return true;
    } else if (_convNumber == 16) {
      return true;
    } else if (_convNumber == 17) {
      return true;
    } else if (_convNumber == 18) {
      return true;
    } else if (_convNumber == 19) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

boolean consecutiveString(String _userCharacter, String _computerCharacter, int _convNumber) {

  if ((_userCharacter == "Horny") && (_computerCharacter == "Troll")) {
    if (_convNumber == 0) {
      return true;
    } else if (_convNumber == 17) {
      return true;
    } else if (_convNumber == 18) {
      return true;
    } else  if (_convNumber == 20) {
      return true;
    } else  if (_convNumber == 22) {
      return true;
    } else  if (_convNumber == 26) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Troll") && (_computerCharacter == "Horny")) {
    if (_convNumber == 10) {
      return true;
    } else  if (_convNumber == 18) {
      return true;
    } else  if (_convNumber == 21) {
      return true;
    } else  if (_convNumber == 26) {
      return true;
    } else  if (_convNumber == 28) {
      return true;
    } else  if (_convNumber == 29) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Horny") && (_computerCharacter == "Whimsical")) {
    return false;
  } else if ((_userCharacter == "Whimsical") && (_computerCharacter == "Horny")) {
    if (_convNumber == 13) {
      return true;
    } else  if (_convNumber == 14) {
      return true;
    } else  if (_convNumber == 15) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Moral") && (_computerCharacter == "Pitiful")) {
    if (_convNumber == 6) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Pitiful") && (_computerCharacter == "Moral")) {
    if (_convNumber == 3) {
      return true;
    } else if (_convNumber == 4) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Moral") && (_computerCharacter == "Whimsical")) {
    if (_convNumber == 0) {
      return true;
    } else if (_convNumber == 4) {
      return true;
    } else if (_convNumber == 5) {
      return true;
    } else if (_convNumber == 7) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Whimsical") && (_computerCharacter == "Moral")) {
    if (_convNumber == 2) {
      return true;
    } else if (_convNumber == 6) {
      return true;
    } else if (_convNumber == 7) {
      return true;
    } else if (_convNumber == 8) {
      return true;
    } else if (_convNumber == 11) {
      return true;
    } else if (_convNumber == 12) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Passive") && (_computerCharacter == "Poseur")) {
    if (_convNumber == 8) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Poseur") && (_computerCharacter == "Passive")) {
    if (_convNumber == 2) {
      return true;
    } else if (_convNumber == 3) {
      return true;
    } else if (_convNumber == 4) {
      return true;
    } else if (_convNumber == 10) {
      return true;
    } else if (_convNumber == 20) {
      return true;
    } else if (_convNumber == 22) {
      return true;
    } else if (_convNumber == 23) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Passive") && (_computerCharacter == "Pitiful")) {
    if (_convNumber == 4) {
      return true;
    } else if (_convNumber == 6) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Pitiful") && (_computerCharacter == "Passive")) {
    return false;
  } else if ((_userCharacter == "Poseur") && (_computerCharacter == "Troll")) {
    if (_convNumber == 5) {
      return true;
    } else  if (_convNumber == 6) {
      return true;
    } else {
      return false;
    }
  } else if ((_userCharacter == "Troll") && (_computerCharacter == "Poseur")) {
    if (_convNumber == 4) {
      return true;
    } else if (_convNumber == 5) {
      return true;
    } else if (_convNumber == 13) {
      return true;
    } else if (_convNumber == 15) {
      return true;
    } else if (_convNumber == 16) {
      return true;
    } else if (_convNumber == 17) {
      return true;
    } else if (_convNumber == 18) {
      return true;
    } else if (_convNumber == 19) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

/////////////////////////////////////////////////////////////////
//   used to initialise buttons. this is called in setup()     //
/////////////////////////////////////////////////////////////////

void initButtons() {
  rectMode(CENTER);
  buttoncolor = color(60, 60);
  highlight = color(255, 0, 0, 80);
  invisible = color(255);
  menuBut1 = new RectButton(width/2, round(0.2857142857*height), round(width*0.29761904761905), round(height*0.09523809524), invisible, invisible, "menuBut1");
  menuBut2 = new RectButton(width/2, round(height*0.380952381), round(width*0.29761904761905), round(height*0.09523809524), invisible, invisible, "menuBut2");
  menuBut3 = new RectButton(width/2, round(height*0.4761904762), round(width*0.29761904761905), round(height*0.09523809524), invisible, invisible, "menuBut3");
  menuBut4 = new RectButton(width/2, round(height*0.5714285714), round(width*0.29761904761905), round(height*0.09523809524), invisible, invisible, "menuBut4");
  menuBut5 = new RectButton(width/2, round(height*0.6666666667), round(width*0.29761904761905), round(height*0.09523809524), invisible, invisible, "menuBut5");
  menuBut6 = new RectButton(width/2, round(height*0.7619047619), round(width*0.29761904761905), round(height*0.09523809524), invisible, invisible, "menuBut6");
  menuBut7 = new RectButton(width/2, round(height*0.8571428571), round(width*0.29761904761905), round(height*0.09523809524), invisible, invisible, "menuBut7");
  sendBut = new RectButton(width-width/3, height - round(height*0.09523809524), width/3, round(height*0.09523809524), buttoncolor, highlight, "sendBut");
  replyBut = new RectButton(5*width/6, height - round(height*0.09523809524), width/3, round(height*0.09523809524), buttoncolor, highlight, "replyBut");
  returnBut = new RectButton(width/6, height - round(height*0.09523809524), width/3, round(height*0.09523809524), buttoncolor, highlight, "returnBut");
  returnBut2 = new RectButton(width/6, height - round(height*0.09523809524), width/3, round(height*0.09523809524), buttoncolor, highlight, "returnBut2");
  otherBut = new RectButton(width/2, height - round(height*0.09523809524), width/3, round(height*0.09523809524), buttoncolor, highlight, "otherBut");
  playBut = new RectButton(5*width/6, height - round(height*0.09523809524), width/3, round(height*0.09523809524), buttoncolor, highlight, "playBut");
}

//change the colour here
color lerpColourNoTimer(color basecolor, color highlightcolor, int _low, int _high, int _amount) {
  int base_red = int(red(basecolor));
  int base_green = int(green(basecolor));
  int base_blue = int(blue(basecolor));
  int high_red  = int(red(highlightcolor));
  int high_green  = int(green(highlightcolor));
  int high_blue  = int(blue(highlightcolor));
  int base_alpha = int(alpha(basecolor));
  int high_alpha = int(alpha(highlightcolor));

  float current_red = lerp(base_red, high_red, map(_amount, _low, _high, 0., 1.));
  float current_green = lerp(base_green, high_green, map(_amount, _low, _high, 0., 1.));
  float current_blue = lerp(base_blue, high_blue, map(_amount, _low, _high, 0., 1.));
  float current_alpha = lerp(base_alpha, high_alpha, map(_amount, _low, _high, 0., 1.));

  if (_amount <= _high) {
    return highlightcolor;
  } else {
    return color(current_red, current_green, current_blue, current_alpha);
  }
}

/////////////////////////////////////////////////////////////////
//  iterate through convo arrays here using convNumber counter //
/////////////////////////////////////////////////////////////////

void mousePressed() {
  //if send message == true

  if (sendBut.pressed() || replyBut.pressed()) {
    println("string index: (" + userConvNumber + "/" + stringLength + ")");
    println("sample index: (" + compConvNumber + "/" + sampleLength + ")");
    println("convScreenManager: " + convScreenManager);
    println("state: " + state);
    println("user: " + user + " computer: " + computer);
    //if computer sample play state
    if (convScreenManager == 3) {

      if ((userConvNumber == stringLength) && (compConvNumber == sampleLength)) {
        println("String has the last word and now disconnecting (see mousePressed())");
        convScreenManager = 5;
      } else {

        compConvNumber++;

        if (!consecutive) {
          convScreenManager = 2;
        } else {
          println("consecutive sample == true!");
          betterTypeWriter.reset();
        }
      }

      //if user string display state
    } else if (convScreenManager == 2) {

      if ((userConvNumber == stringLength) && (compConvNumber == sampleLength)) {

        convScreenManager = 5;
      } else if ((userConvNumber == stringLength) && (compConvNumber < sampleLength)) {

        convScreenManager = 6;
      } else if ((userConvNumber == stringLength) && (compConvNumber == sampleLength + 1)) {

        convScreenManager = 5;
      } else {
        if (betterTypeWriter.counter < currentString.length()) {
          betterTypeWriter.counter = currentString.length();
        } else {
          moveThatAss = true;
        }
      }
    }
  } else if ((returnBut.pressed()) || (returnBut2.pressed())) {

    initSprings();
    allowBothToSpeak = 0;
    userConvNumber = 0; 
    compConvNumber = 0; 
    lockMenu.start();
    inConversation = false;
    convScreenManager = 0;
    state = 0;
  } else if (playBut.pressed() && inConversation == false) {

    convScreenManager = 0;
    betterTypeWriter.primer.start();
    println("play button pressed");
    initSprings();
    inConversation = true; //we are in conversation!!!
    connectingTimer.start();
  }
}

/////////////////////////////////////////////////////////////////
//  This is the function that iterates through the various     //
//  screens of a conversation. It takes the arguments of the   //
//  user's conversation strings (array) and the computer's     //
//  side of the conversation but with samples. As well as that //
//  the opening question is sent through as a string. it also  //
//  takes a boolean of who's starting, which is imperative to  //
//  what state this function is in.                            //
/////////////////////////////////////////////////////////////////

void conversationDisplay(String _user, String _computer, String[] _userString, AudioPlayer[] _computerSample, String _openingQuestion, boolean _userStarts, boolean _userDisconnects) {
  //  println("User: " + _user + " Computer: " + _computer);
  //  println("User array index: " + userConvNumber);
  //  println("Computer array index: " + compConvNumber);
  //

  menuButtonsLock();

  //global scope samples for conditionals and debugging
  user = _user;
  computer = _computer;
  stringLength = _userString.length - 1;
  sampleLength = _computerSample.length - 1;
  userDisconnects = _userDisconnects;
  currentString = _userString[userConvNumber];

  switch (convScreenManager) {
  case 0:
    //run connecting screen
    if (millis() - connectingTimer.savedTime > 7000) {
      background(lerpColour(whiteCol, babyBlueCol, width/2, height/2, width, height, 7));
      //mrLoad.display(width/2, height/2 - round(height*0.09523809524), lerpColour(redCol, blueCol, width/2, height/2, width, height, 7));
      mrLoad.display(width/2, height/2 - round(height*0.09523809524), blueCol);
    } else {
      PVector loadingPV = transition(top, width/2, height/2 - round(height*0.09523809524));
      lerpTimers[7].start();
      mrLoad.display(int(loadingPV.x), int(loadingPV.y), blueCol);
      PVector circleSpring = fromCentre.horizontalSpring(width/2 + round(width*0.05952380952381), height/2);
      mrLoad.radius = int(circleSpring.x) - width/2;
    }
    //who is the user?
    fill(0);
    textAlign(RIGHT);
    textFont(thinFont42);
    text("You Are Playing As: " + _user, width - _user.length() - round(width*0.0297619047619), round(height*0.04761904762));
    textAlign(CENTER);
    textFont(regularFont60);

    PVector connectingText = transition(bottom, width/2, height/2 + round(height*0.1904761905));
    betterTypeWriter.loadText("Waiting for connection", int(connectingText.x), connectingText.y);

    if (connectingTimer.isFinished()) {
      betterTypeWriter.reset();
      convScreenManager = 1;
      openingQuestionTimer.start();
    }
    break;

  case 1:
    fill(0);
    betterTypeWriter.reset();
    background(babyBlueCol);
    //who is the user?
    fill(0);
    textAlign(RIGHT);
    textFont(thinFont42);
    text("You Are Playing As: " + _user, width - _user.length() - round(width*0.0297619047619), round(height*0.04761904762));
    textAlign(CENTER);
    textFont(regularFont60);
    //next run opening question
    text("Connection Found!", width/2, height/2 - round(0.2857142857*height));
    textFont(thickFont60);
    text("Opening Question:", width/2, height/2 - round(height*0.09523809524));
    text(_openingQuestion, width/2, height/2 + round(height*0.1904761905), width - 100, round(height*0.47619047619048));
    //depending on who starts first iterate through the arrays in a certain order
    if (openingQuestionTimer.isFinished()) {
      if (_userStarts) {
        convScreenManager = 2;
      } else {
        incomingMessageTimer.start();
        convScreenManager = 4;
      }
    }
    break;

  case 2:
    if (compConvNumber > 0) {
      _computerSample[compConvNumber - 1].pause();
    }

    if (!consecutive && transitionTime) {
      incomingMessageTimer.start();
      //incoming message state
      convScreenManager = 6;
      println("user conv number = " + userConvNumber);
    }

    replyBut.locked = true;
    returnBut.locked = true;
    otherBut.locked = true;

    //my response: string
    fill(0);
    background(babyBlueCol);
    //who is the user?
    fill(0);
    textAlign(RIGHT);
    textFont(thinFont42);
    text("You Are Playing As: " + _user, width - _user.length() - round(width*0.0297619047619), round(height*0.04761904762));
    textAlign(CENTER);
    textFont(regularFont60);

    if (consecutiveString(_user, _computer, userConvNumber)) {     
      consecutive = true;
    } else {
      consecutive = false;
    }

    if (alphaText <= 0) {
      alphaText = 0;
    }

    if (moveThatAss) {
      //move
      textHeight -= round(0.02857142857143*height);
      black = color(0);
      //ensure all chars are there
      betterTypeWriter.counter = _userString[userConvNumber].length();
      //display
      betterTypeWriter.typeWriter(_userString[userConvNumber], 16, 100, 220, 1000, width/2 - 150, textHeight, width-150, round(height*0.4761904762), lerpColourNoTimer(black, babyBlueCol, height/2 + round(height*0.19047619047619), height/3, textHeight));
    } else {
      betterTypeWriter.typeWriter(_userString[userConvNumber], 16, 100, 220, 1000, width/2 - 150, height/2 + round(height*0.19047619047619), width-150, round(height*0.4761904762), color(0));
    }

    sendBut.display();
    fill(0);
    if (betterTypeWriter.counter >= _userString[userConvNumber].length()) {
      text("Send", sendBut.x, sendBut.y + round(height*0.01904761905));
    } else {
      if (transitionTime) {
        text("Send", sendBut.x, sendBut.y + round(height*0.01904761905));
      } else {
        text("Finish", sendBut.x, sendBut.y + round(height*0.01904761905));
      }
    }
    //disconect button
    returnBut2.display();
    fill(0);
    //realign after some spring fun in a previous state
    returnBut2.x = width/3;
    returnBut2.y = sendBut.y;
    text("Disconnect", returnBut2.x, returnBut2.y + round(height*0.01904761905));

    if (textHeight <= 0) {
      userConvNumber++;
      betterTypeWriter.reset();
      transitionTime = true;
      textHeight = height/2 + round(height*0.19047619047619);
      moveThatAss = false;
    } else {
      transitionTime = false;
    }
    break;

  case 3:
    if (returnBut.pressed() && mousePressed) {
      _computerSample[compConvNumber].pause();
    }

    _computerSample[compConvNumber].play();

    sendBut.locked = true;
    returnBut2.locked = true;  

    fill(0);
    background(babyBlueCol);
    //who is the user?
    fill(0);
    textAlign(RIGHT);
    textFont(thinFont42);
    text("You Are Talking To: " + _computer, width - _computer.length() - round(width*0.0297619047619), round(height*0.04761904762));
    textAlign(CENTER);
    textFont(regularFont60);

    if (replyBut.pressed() && mousePressed) {
      _computerSample[compConvNumber - 1].pause();
    }

    //send button
    replyBut.display();
    fill(0);
    if (!consecutiveSample(_computer, _user, compConvNumber)) {
      consecutive = false;
      text("Reply", replyBut.x, replyBut.y + round(height*0.01904761905));
    } else {
      consecutive = true;
      text("New Message!", replyBut.x, replyBut.y + round(height*0.01904761905));
    }
    //disconect button
    returnBut.x = width/6;
    returnBut.display();
    fill(0);
    text("Disconnect", returnBut.x, returnBut.y + round(height*0.01904761905));

    //listen to again button
    fill(0);
    text("Listen Again", otherBut.x, otherBut.y + round(height*0.01904761905));
    otherBut.display();

    betterTypeWriter.reset();

    if (otherBut.pressed() && mousePressed) {
      //play sample again
      _computerSample[compConvNumber].play(0);
    }
    //DING!
    //respond/listen again/disconnect button
    break;

  case 4:
    background(babyBlueCol);
    //who is the user?
    fill(0);
    textAlign(RIGHT);
    textFont(thinFont42);
    text("You Are Playing As: " + _user, width - _user.length() - round(width*0.0297619047619), round(height*0.04761904762));
    textAlign(CENTER);
    textFont(regularFont60);
    //incoming message
    //anon is typing...
    mrLoad.display(width/2, height/2 - round(height*0.09523809524), blueCol);

    betterTypeWriter.loadText("Incoming Message", width/2, height/2 + round(height*0.19047619047619));

    if (incomingMessageTimer.isFinished()) {

      playOnce = true;
      convScreenManager = 3;
    }
    break;

  case 5:
    background(babyBlueCol);
    //disconect button
    returnBut.x = width/2;
    returnBut.display();
    fill(0);
    text("Disconnect", returnBut.x, returnBut.y + round(height*0.01904761905));
    replyBut.locked = true;
    sendBut.locked = true;
    otherBut.locked = true;
    returnBut2.locked = true;

    if (returnBut.pressed() && mousePressed) {
      _computerSample[compConvNumber].pause();
    }

    //who is the user?
    fill(0);
    textAlign(RIGHT);
    textFont(thinFont42);
    text("You Are Playing As: " + _user, width - _user.length() - round(width*0.0297619047619), round(height*0.04761904762));
    textAlign(CENTER);
    textFont(regularFont60);

    if (!_userDisconnects) {
      text("The " + _computer + " disconnected!", width/2, height/2);
    }
    break;


  case 6: 

    background(babyBlueCol);
    //who is the user?
    fill(0);
    textAlign(RIGHT);
    textFont(thinFont42);
    text("You Are Playing As: " + _user, width - _user.length() - round(width*0.0297619047619), round(height*0.04761904762));
    textAlign(CENTER);
    textFont(regularFont60);
    //incoming message
    //anon is typing...
    mrLoad.display(width/2, height/2 - round(height*0.09523809524), blueCol);
    text("Message sent!", width/2, height/2 + round(height*0.19047619047619));
    betterTypeWriter.loadText("Awaiting Response", width/2, height/2 + round(height*0.380952381));
    if (incomingMessageTimer.isFinished()) {
      //userConvNumber++;
      convScreenManager = 3;
    }
    break;
  }
}

void menuButtonsLock() {
  menuBut1.locked = true;
  menuBut2.locked = true;
  menuBut3.locked = true;
  menuBut4.locked = true;
  menuBut5.locked = true;
  menuBut6.locked = true;
  menuBut7.locked = true;
}

void timedMenuButtonsLock() {
  if (!lockMenu.isFinished()) {
    timerLock = true;
    menuBut1.locked = true;
    menuBut2.locked = true;
    menuBut3.locked = true;
    menuBut4.locked = true;
    menuBut5.locked = true;
    menuBut6.locked = true;
    menuBut7.locked = true;
  } else {
    timerLock = false;
  }
}


void initSprings() {
  fromLeft = new Spring(false, false, round(width*0.29761904761905));
  fromRight = new Spring(true, false, round(width*0.29761904761905));
  fromTop = new Spring(false, false, round(height*0.4761904762));
  fromBottom = new Spring(false, true, round(height*0.4761904762));
  fromCentre = new Spring(false, false, width/2);
}

/////////////////////////////////////////////////////////////////
//      Initialise the character classes neatly in here!!!     //
/////////////////////////////////////////////////////////////////

void initCharacterClasses() {
  horny = new Horny();
  moral = new Moral();
  passive = new Passive();
  pity = new Pity();
  poseur = new Poseur();
  troll = new Troll();
  whimsical = new Whimsical();
}

void loadClassSamples() {
  horny0 = new AudioPlayer[31]; // horny side of the horny/troll interaction
  horny1 = new AudioPlayer[14]; // horny side of the horny/whimsical interaction
  moral0 = new AudioPlayer[15]; // Moral side of the Moral/pity interaction
  moral1 = new AudioPlayer[10]; // Moral side of the Moral/whimsical interaction
  passive0 = new AudioPlayer[10]; // Passive side of the Passive/pity interaction
  passive1 = new AudioPlayer[18]; // Passive side of the Passive/poseur interaction
  pity0 = new AudioPlayer[14]; // Pity side of the Pity/moral interaction
  pity1 = new AudioPlayer[8]; // Pity side of the Pity/passive interaction
  poseur0 = new AudioPlayer[24]; // Poseur side of the Poseur/passive interaction
  poseur1 = new AudioPlayer[16]; // Poseur side of the Poseur/troll interaction
  troll0 = new AudioPlayer[23]; // Troll side of the Troll/poseur interaction
  troll1 = new AudioPlayer[29]; // Troll side of the Troll/horny interaction
  whimsical0 = new AudioPlayer[17]; // Whimsical side of the horny/Whimsical interaction
  whimsical1 = new AudioPlayer[14]; // Whimsical side of the Moral/whimsical interaction

  //load the horny of the horny/troll samples
  for (int i = 0; i < horny0.length; i++) {
    horny0[i] = minim.loadFile("HornyTr" + (i + 1) + ".mp3");
  }
  //load the horny of the horny/whimsical samples
  for (int i = 0; i < horny1.length; i++) {
    horny1[i] = minim.loadFile("Hornywh" + (i + 1) + ".mp3");
  }
  //load the horny of the horny/troll samples
  for (int i = 0; i < moral0.length; i++) {
    moral0[i] = minim.loadFile("Moralpp" + (i + 1) + ".mp3");
  }
  //load the horny of the horny/whimsical samples
  for (int i = 0; i < moral1.length; i++) {
    moral1[i] = minim.loadFile("Moralwh" + (i + 1) + ".mp3");
  }
  //load the horny of the horny/troll samples
  for (int i = 0; i < passive0.length; i++) {
    passive0[i] = minim.loadFile("Passivepp" + (i + 1) + ".mp3");
  }
  //load the horny of the horny/whimsical samples
  for (int i = 0; i < passive1.length; i++) {
    passive1[i] = minim.loadFile("Passiveso" + (i + 1) + ".mp3");
  }
  for (int i = 0; i < pity0.length; i++) {
    pity0[i] = minim.loadFile("Pitifulmo" + (i + 1) + ".mp3");
  }

  for (int i = 0; i < pity1.length; i++) {
    pity1[i] = minim.loadFile("Pitifulpa" + (i + 1) + ".mp3");
  }
  //load the poseur of the poseur/passive samples
  for (int i = 0; i < poseur0.length; i++) {
    poseur0[i] = minim.loadFile("Poseurpa" + (i + 1) + ".mp3");
  }
  //load the poseur of the poseur/troll samples
  for (int i = 0; i < poseur1.length; i++) {
    poseur1[i] = minim.loadFile("Poseurtr" + (i + 2) + ".mp3");
  }
  //load the horny of the troll/poseur samples
  for (int i = 0; i < troll0.length; i++) {
    troll0[i] = minim.loadFile(dataPath("Trollso" + (i + 1) + ".mp3"));
  }
  //load the horny of the troll/horny samples
  for (int i = 0; i < troll1.length; i++) {
    troll1[i] = minim.loadFile(dataPath("Trollho" + (i + 1) + ".mp3"));
  }
  //load the horny of the whim/horny samples
  for (int i = 0; i < whimsical0.length; i++) {
    whimsical0[i] = minim.loadFile(dataPath("Whimho" + (i + 1) + ".mp3"));
  }
  //load the horny of the whim/moral samples
  for (int i = 0; i < whimsical1.length; i++) {
    whimsical1[i] = minim.loadFile(dataPath("Whimmo" + (i + 1) + ".mp3"));
  }
}

