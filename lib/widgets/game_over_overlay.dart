import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverOverlay extends StatelessWidget {
  final bool isDarkMode;
  final int score;
  final VoidCallback onPlayAgain;

  const GameOverOverlay({
    super.key,
    required this.isDarkMode,
    required this.score,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black87 : Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Over',
              style: GoogleFonts.pressStart2p(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Score: $score',
              style: GoogleFonts.pressStart2p(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPlayAgain,
              child: Text(
                'Play Again',
                style: GoogleFonts.pressStart2p(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
