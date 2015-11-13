/*

 This will serve as the blueprint for all conversation types to extend
 
 */

abstract class Conversation {
 
  int conversationStage; //a counter var to iterate through array indexes

  //these strings are used as switch expressions for functions to run code for the right sample arrays
  char partner0;
  char partner1;
  
  //declare two string arrays
  String[] chat0, chat1;
  

  Conversation() {
    
    conversationStage = 0; //all the conversations will begin at the start
    
  }
}
