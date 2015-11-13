/*
  Passive class loads sounds files and strings pertaining to the passive converstation branches
  
  it inherits the play, stop and reset function from the conversation 'big daddy' class which all take one argument - the index of the sample array
    
    Paired:- //(these will need to be played one after another in the same state/screen)
    Passive/pity - passive 7/8
    
*/

class Passive extends Conversation {
  
  Passive() {
    super();
    
    //these arguments are used in the super class as a switch expression for things like play and pause functions
    partner0 = 'p'; //pity
    partner1 = 's'; //showoff (poseur)
    

    loadMyStrings(); //loads the strings into the two arrays by parsing two text documents
  }

  void loadMyStrings() {
    chat0 = loadStrings("passive_passiveNpity.txt");
    chat1 = loadStrings("passive_passiveNposeur.txt");
  }
}
