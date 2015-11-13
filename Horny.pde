 /*
  Horny class loads sounds files pertaining to the horny converstation branches
  
  it inherits the play, stop and reset function from the conversation 'big daddy' class which all take one argument - the index of the sample array
    
    Paired:- h/t //(these will need to be played one after another in the same state/screen)
    - 18, 19, 20
    - 21, 22
    - 23, 24
    - 27, 28
*/

class Horny extends Conversation {
  
  Horny() {
    super();
    

    //these arguments are used in the super class as a switch expression for things like play and pause functions
    partner0 = 't'; //troll
    partner1 = 'w'; //whimscal
    
    loadMyStrings(); //loads the strings into the two arrays by parsing two text documents
  }

  void loadMyStrings() {
    chat0 = loadStrings("horny_hornyNtroll.txt");
    chat1 = loadStrings("horny_hornyNwhimsical.txt");
  }
}
