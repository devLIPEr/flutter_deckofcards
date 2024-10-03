import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deckofcards_api/common/util.dart';

/// Create a new deck of cards
/// 
/// @param numOfDecks - the number of decks to shuffle together
Future<Map> createDeck(int numOfDecks) async{
  http.Response response;
  response = await http.get(Uri.parse("https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=$numOfDecks"));
  return json.decode(response.body);
}

/// Draw cards from a deck
/// 
/// @param deckId - the deck id
///
/// @param int numCards - number of cards to draw
Future<Map> drawCards(String deckId, int numCards) async{
  http.Response response;
  response = await http.get(Uri.parse("https://deckofcardsapi.com/api/deck/$deckId/draw/?count=$numCards"));
  return json.decode(response.body);
}

/// Shuffle all cards back to deck
/// 
/// @param deckId - the deck id
Future<Map> shuffleDeck(String deckId, bool remaining) async{
  http.Response response;
  response = await http.get(Uri.parse("https://deckofcardsapi.com/api/deck/$deckId/shuffle/?remaining=$remaining"));
  return json.decode(response.body);
}

/// Add cards to pile
/// 
/// @param deckId - the deck id
/// 
/// @param pileName - the name of the pile to add the cards
/// 
/// @param cards - a list of cards to be put in the pile
Future<Map> addToPile(String deckId, String pileName, List<String> cards) async{
  http.Response response;
  response = await http.get(Uri.parse("https://deckofcardsapi.com/api/deck/$deckId/pile/$pileName/add/?cards=${Util.commaSeparatedList(cards)}"));
  return json.decode(response.body);
}

/// List cards in a pile
/// 
/// @param deckId - the deck id
/// 
/// @param pileName - the name of the pile
Future<Map> listPile(String deckId, String pileName) async{
  http.Response response;
  response = await http.get(Uri.parse("https://deckofcardsapi.com/api/deck/$deckId/pile/$pileName/list/"));
  return json.decode(response.body)["piles"][pileName];
}

/// Shuffle back cards from a pile to the deck
/// 
/// @param deckId - the deck id
/// 
/// @param pileName - the name of the pile
Future<Map> returnFromPile(String deckId, String pileName) async{
  http.Response response;
  response = await http.get(Uri.parse("https://deckofcardsapi.com/api/deck/$deckId/pile/$pileName/return/"));
  return json.decode(response.body);
}