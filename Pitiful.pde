/*
  Pity class loads sounds files and strings pertaining to the Pity converstation branches
  
  it inherits the play, stop and reset function from the conversation 'big daddy' class which all take one argument - the index of the sample array
    
    Paired:- //(these will need to be played one after another in the same state/screen)
    p/p - 7/8
*/

class Pity extends Conversation {
  
  Pity() {
    super();
        
    //these arguments are used in the super class as a switch expression for things like play and pause functions //<>//
    partner0 = 'm'; //moral
    partner1 = 'p'; //passive
    
   
    loadMyStrings(); //loads the strings into the two arrays by parsing two text documents
  }
  
  
  void loadMyStrings() {
    chat0 = loadStrings("pity_pityNmoral.txt");
    chat1 = loadStrings("pity_pityNpassive.txt");
  }
}
