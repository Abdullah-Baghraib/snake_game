import 'dart:math';

enum Direction { up, down, left, right }

class SnakeGame {
  List<Point<int>> snake = [];
  Point<int> food = const Point(0, 0);
  Direction direction = Direction.right;
  int score = 0;
  bool isGameOver = false;
  final int gridSize;
  final Random random = Random();
  double baseSpeed = 400.0; 
  double currentSpeed = 400.0; 
  double speedIncrease = 2.0; 

  SnakeGame({required this.gridSize}) {
    resetGame();
  }

  void resetGame() {
    snake = [
      Point(gridSize ~/ 2, gridSize ~/ 2),
      Point(gridSize ~/ 2 - 1, gridSize ~/ 2),
    ];
    direction = Direction.right;
    score = 0;
    isGameOver = false;
    currentSpeed = baseSpeed;
    generateFood();
  }

  void generateFood() {
    while (true) {
      food = Point(random.nextInt(gridSize), random.nextInt(gridSize));
      if (!snake.contains(food)) break;
    }
  }

  bool move() {
    if (isGameOver) return false;

    final head = snake.first;
    Point<int> newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Check for collisions
    if (newHead.x < 0 ||
        newHead.x >= gridSize ||
        newHead.y < 0 ||
        newHead.y >= gridSize ||
        snake.contains(newHead)) {
      isGameOver = true;
      return false;
    }

    snake.insert(0, newHead);

    if (newHead == food) {
      score++;
      currentSpeed = max(
        50.0,
        currentSpeed - speedIncrease,
      ); 
      generateFood();
    } else {
      snake.removeLast();
    }

    return true;
  }

  void changeDirection(Direction newDirection) {
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    direction = newDirection;
  }
}
