/*
  Moral class loads sounds files and strings pertaining to the Moral converstation branches
  
  it inherits the play, stop and reset function from the conversation 'big daddy' class which all take one argument - the index of the sample array
    
    Paired:- //(these will need to be played one after another in the same state/screen)
    - m/p 7/8
    
    - m/w 4/5/6
          7/8
*/

class Moral extends Conversation {
  
  Moral() {
    super();
    
    //these arguments are used in the super class as a switch expression for things like play and pause functions
    partner0 = 'p'; //pity
    partner1 = 'w'; //whimscal
    
    
    loadMyStrings(); //loads the strings into the two arrays by parsing two text documents
  }

  void loadMyStrings() {
    chat0 = loadStrings("moral_moralNpity.txt");
    chat1 = loadStrings("moral_moralNwhimsical.txt");
  }
}
