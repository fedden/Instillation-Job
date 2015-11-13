/*
  Troll class loads sounds files and strings pertaining to the Troll converstation branches
  
  it inherits the play, stop and reset function from the conversation 'big daddy' class which all take one argument - the index of the sample array
    
    Paired:- //(these will need to be played one after another in the same state/screen)
    troll/p - 6,7,8 - 15,16 - 17,18,19,20,21
    troll/h - 11,12 - 25,26 - 27,28,29
*/

class Troll extends Conversation {
  
  Troll() {
    super();

    //these arguments are used in the super class as a switch expression for things like play and pause functions
    partner0 = 'p'; //poseur
    partner1 = 'h'; //horny

    loadMyStrings(); //loads the strings into the two arrays by parsing two text documents
  }
  
  void loadMyStrings() {
    chat0 = loadStrings("troll_trollNposeur.txt");
    chat1 = loadStrings("troll_trollNhorny.txt");
    
  }
}
