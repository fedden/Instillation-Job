/*
  Poseur class loads sounds files and strings pertaining to the Poseur converstation branches
  
  it inherits the play, stop and reset function from the conversation 'big daddy' class which all take one argument - the index of the sample array
    
    Paired:- //(these will need to be played one after another in the same state/screen)
    
    p/p 3,4,5,6 - 11/12
    p/t 6/7/8
*/

class Poseur extends Conversation {
  
  Poseur() {
    super();
    

    //these arguments are used in the super class as a switch expression for things like play and pause functions
    partner0 = 'p'; //passive
    partner1 = 't'; //troll

    loadMyStrings(); //loads the strings into the two arrays by parsing two text documents
  }
  

  void loadMyStrings() {
    chat0 = loadStrings("poseur_poseurNpassive.txt");
    chat1 = loadStrings("poseur_poseurNtroll.txt");
  }
}
