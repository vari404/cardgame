import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';
import 'card_widget.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Card Matching Game'),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  gameProvider.resetGame();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Display Timer and Score
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time: ${gameProvider.timeElapsed}s',
                        style: TextStyle(fontSize: 18)),
                    Text('Score: ${gameProvider.score}',
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              // Game Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Adjust for grid size
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: gameProvider.cards.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      card: gameProvider.cards[index],
                      onTap: () {
                        gameProvider.flipCard(gameProvider.cards[index]);
                      },
                    );
                  },
                ),
              ),
              // Victory Message
              if (gameProvider.isGameOver)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Congratulations! You won!',
                    style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
