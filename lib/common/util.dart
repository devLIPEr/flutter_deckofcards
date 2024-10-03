class Util {
  static Map<String, int> cardValue = {
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
    "7": 7,
    "8": 8,
    "9": 9,
    "10": 10,
    "JACK": 10,
    "QUEEN": 10,
    "KING": 10,
    "ACE": 1
  };

  /// Gets a List as a string separated by commans only
  /// 
  /// @param list - a list of Strings to get
  /// 
  /// @return - a string in the format 1,2,3
  /// 
  /// @reference - https://stackoverflow.com/questions/63887180/printing-the-elements-of-list-inline
  static String commaSeparatedList(List<String> list) => list.toString().replaceAll(RegExp(r'^\[| |\]'), '');

  /// Gets card value as int instead of String
  /// 
  /// @param value - a String value
  /// 
  /// @return - a integer value
  static int getCardValue(String value) => cardValue[value] ?? 0;
}