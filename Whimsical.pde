/*
  Moral class loads sounds files and strings pertaining to the Moral converstation branches
  
  it inherits the play, stop and reset function from the conversation 'big daddy' class which all take one argument - the index of the sample array
    
    Paired:- //(these will need to be played one after another in the same state/screen)
    w/h = 14,15,16,17
    w/m = 3,4 - 7,8,9,10 - 12,13,14
*/

class Whimsical extends Conversation {
  
  Whimsical() {
    super();
    

    
    //these arguments are used in the super class as a switch expression for things like play and pause functions
    partner0 = 'h'; //horny
    partner1 = 'm'; //moral
    

    loadMyStrings(); //loads the strings into the two arrays by parsing two text documents
  }
  

  
  void loadMyStrings() {
    chat0 = loadStrings("whimsical_whimsicalNhorny.txt");
    chat1 = loadStrings("whimsical_whimsicalNmoral.txt");
  }
}
