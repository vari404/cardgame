import 'package:flutter/material.dart';
import 'card_model.dart';
import 'dart:async';

class GameProvider with ChangeNotifier {
  List<CardModel> _cards = [];
  List<CardModel> _flippedCards = [];
  int _score = 0;
  int _timeElapsed = 0;
  Timer? _timer;
  bool _isGameOver = false;

  GameProvider() {
    _initializeGame();
  }

  // Getters
  List<CardModel> get cards => _cards;
  int get score => _score;
  int get timeElapsed => _timeElapsed;
  bool get isGameOver => _isGameOver;

  // Initialize the game
  void _initializeGame() {
    _isGameOver = false;
    _score = 0;
    _timeElapsed = 0;
    _flippedCards = [];
    _cards = [];

    // List of emojis
    List<String> emojis = [
      '🚀',
      '🎉',
      '😊',
      '🐱',
      '🌟',
      '🔥',
      '💎',
      '🍀',
    ];

    // Duplicate and shuffle emojis to create pairs
    emojis = [...emojis, ...emojis];
    emojis.shuffle();

    // Create CardModel instances
    _cards = emojis.asMap().entries.map((entry) {
      int index = entry.key;
      String emoji = entry.value;
      return CardModel(id: index, emoji: emoji);
    }).toList();

    _startTimer();
    notifyListeners();
  }

  // Start the timer
  void _startTimer() {
    _timer?.cancel(); // Cancel existing timer if any
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timeElapsed++;
      notifyListeners();
    });
  }

  // Flip a card
  void flipCard(CardModel card) {
    if (_flippedCards.length >= 2 ||
        card.isFaceUp ||
        card.isMatched ||
        _isGameOver) {
      return;
    }

    card.isFaceUp = true;
    _flippedCards.add(card);
    notifyListeners();

    if (_flippedCards.length == 2) {
      _checkMatch();
    }
  }

  // Check for a match
  void _checkMatch() async {
    await Future.delayed(Duration(milliseconds: 500));

    if (_flippedCards[0].emoji == _flippedCards[1].emoji) {
      _flippedCards[0].isMatched = true;
      _flippedCards[1].isMatched = true;
      _score += 10;
    } else {
      _flippedCards[0].isFaceUp = false;
      _flippedCards[1].isFaceUp = false;
      _score -= 2;
      if (_score < 0) _score = 0;
    }

    _flippedCards.clear();
    notifyListeners();

    _checkGameOver();
  }

  // Check if the game is over
  void _checkGameOver() {
    if (_cards.every((card) => card.isMatched)) {
      _isGameOver = true;
      _timer?.cancel();
      notifyListeners();
    }
  }

  // Reset the game
  void resetGame() {
    _timer?.cancel();
    _initializeGame();
  }

  // Dispose of the timer
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
