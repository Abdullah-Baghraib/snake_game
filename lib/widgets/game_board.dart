import 'package:flutter/material.dart';
import 'dart:math';
import '../models/snake_game.dart';

class GameBoard extends StatelessWidget {
  final SnakeGame game;
  final bool isDarkMode;
  final int gridSize;
  final Function(DragStartDetails) onTouchStart;
  final Function(DragUpdateDetails) onTouchUpdate;

  const GameBoard({
    super.key,
    required this.game,
    required this.isDarkMode,
    required this.gridSize,
    required this.onTouchStart,
    required this.onTouchUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onPanStart: onTouchStart,
        onPanUpdate: onTouchUpdate,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDarkMode ? Colors.white : Colors.black,
              width: 2,
            ),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              final x = index % gridSize;
              final y = index ~/ gridSize;
              final point = Point(x, y);

              if (game.snake.contains(point)) {
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.green : Colors.green[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              } else if (game.food == point) {
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.red : Colors.red[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
