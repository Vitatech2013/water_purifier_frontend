import 'package:flutter/material.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({super.key});

  @override
  _TicTacToeBoardState createState() {
    return _TicTacToeBoardState();
  }
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  List<String> board = ['', '', '', '', '', '', '', '', ''];
  bool isXTurn = true;

  void _onTileTap(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
      });
    }

    String winner = _checkWinner();
    if (winner != '') {
      _showWinnerDialog(winner);
    }
  }

  String _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] != '' &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        return board[combination[0]];
      }
    }

    if (board.every((element) => element != '')) {
      return 'Draw';
    }

    return '';
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(winner == 'Draw' ? 'It\'s a Draw!' : '$winner is the Winner!'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                board = ['', '', '', '', '', '', '', '', ''];
              });
              Navigator.of(context).pop();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 210,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTile(0),
              _buildTile(1),
              _buildTile(2),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTile(3),
              _buildTile(4),
              _buildTile(5),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTile(6),
              _buildTile(7),
              _buildTile(8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int index) {
    return GestureDetector(
      onTap: () => _onTileTap(index),
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 60, // Adjust the width for better appearance
        height: 60, // Adjust the height for better appearance
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black), // Optional: add a border
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: board[index] == 'X' ? Colors.blue : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
