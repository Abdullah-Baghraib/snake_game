import 'package:flutter/material.dart';
import '../models/snake_game.dart';
import '../widgets/game_board.dart';
import '../widgets/game_over_overlay.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late SnakeGame game;
  late AnimationController _controller;
  final int gridSize = 20;
  bool isDarkMode = false;
  bool isPaused = false;
  Offset? touchStart;
  double swipeThreshold = 20.0;

  @override
  void initState() {
    super.initState();
    game = SnakeGame(gridSize: gridSize);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: game.currentSpeed.round()),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && !isPaused) {
          _updateGame();
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
  }

  void _updateGame() {
    if (game.move()) {
      setState(() {
        _controller.duration = Duration(
          milliseconds: game.currentSpeed.round(),
        );
      });
    } else {
      _controller.stop();
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    setState(() {
      isPaused = true;
    });
  }

  void _resetGame() {
    setState(() {
      game.resetGame();
      _controller.duration = Duration(milliseconds: game.currentSpeed.round());
      isPaused = false;
      _controller.reset();
      _controller.forward();
    });
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
      if (isPaused) {
        _controller.stop();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTouchStart(DragStartDetails details) {
    touchStart = details.localPosition;
  }

  void _handleTouchUpdate(DragUpdateDetails details) {
    if (touchStart == null) return;

    final touchCurrent = details.localPosition;
    final dx = touchCurrent.dx - touchStart!.dx;
    final dy = touchCurrent.dy - touchStart!.dy;

    if (dx.abs() > swipeThreshold || dy.abs() > swipeThreshold) {
      if (dx.abs() > dy.abs()) {
        if (dx > 0) {
          game.changeDirection(Direction.right);
        } else {
          game.changeDirection(Direction.left);
        }
      } else {
        if (dy > 0) {
          game.changeDirection(Direction.down);
        } else {
          game.changeDirection(Direction.up);
        }
      }
      touchStart = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score: ${game.score}',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Dark Mode',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: GameBoard(
                        game: game,
                        isDarkMode: isDarkMode,
                        gridSize: gridSize,
                        onTouchStart: _handleTouchStart,
                        onTouchUpdate: _handleTouchUpdate,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _togglePause,
                        child: Text(
                          isPaused ? 'Resume' : 'Pause',
                          style: GoogleFonts.pressStart2p(fontSize: 12),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _resetGame,
                        child: Text(
                          'Restart',
                          style: GoogleFonts.pressStart2p(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (game.isGameOver)
              GameOverOverlay(
                isDarkMode: isDarkMode,
                score: game.score,
                onPlayAgain: _resetGame,
              ),
          ],
        ),
      ),
    );
  }
}
