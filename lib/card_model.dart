class CardModel {
  final int id;
  final String emoji; // Emoji to represent the card
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.id,
    required this.emoji,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}
