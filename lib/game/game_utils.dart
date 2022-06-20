import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_upgraded/objects/square_object.dart';

import '../objects/player.dart';

enum GameType {
  singlePlayer,
  localMultiplayer,
  multiplayer;
}

abstract class GameUtils {
  static const boardLength = 9, numberOfValues = 5, rotationAnimation = 250;

  /// Checks if a [Player] has three in a row, or both [Player]'s have used all moves
  static bool isComplete(List<SquareObject> board, List<bool> player1Values,
      List<bool>? player2Values) {
    return isThreeInARow(board) ||
        (isNoMoreMoves(player1Values) &&
            (player2Values != null ? isNoMoreMoves(player2Values) : true));
  }

  /// Checks if there are three in a row on the [board]
  static bool isThreeInARow(List<SquareObject> board) {
    return _isCompleteHorizontal(board) ||
        _isCompleteVertical(board) ||
        _isCompleteDiagonal(board);
  }

  /// Returns 'true' if all the values of a [Player] has been used
  static bool isNoMoreMoves(List<bool> values) {
    return values.every((element) => element);
  }

  /// returns 'true' if all the squares on the board are used
  @Deprecated("Game can continue as long as a Player has more moves")
  static bool fullBoard(List<SquareObject> board) {
    return board.every((element) => element.value != 0);
  }

  // TODO create recursive functions instead?

  /// Checks if at least one horizontal row is complete
  static bool _isCompleteHorizontal(List<SquareObject> board) {
    for (int i = 0; i < board.length; i += 3) {
      // First column
      bool complete = false;
      for (int j = i + 1; j % 3 != 0; j++) {
        // Second and third column
        complete =
            board[i].player != null && board[i].player == board[j].player;
        if (!complete) {
          // If the first 2 are false, the entire row i false
          break;
        }
      }
      if (complete) {
        return true;
      }
    }
    return false;
  }

  /// Checks if at least one vertical column is complete
  static bool _isCompleteVertical(List<SquareObject> board) {
    for (int i = 0; i < board.length / 3; i++) {
      // First row
      bool complete = false;
      for (int j = i + 3; j < board.length; j += 3) {
        // Second and third row
        complete =
            board[i].player != null && board[i].player == board[j].player;
        if (!complete) {
          break;
        }
      }
      if (complete) {
        return true;
      }
    }
    return false;
  }

  /// Checks if one of the diagonals are complete
  static bool _isCompleteDiagonal(List<SquareObject> board) {
    var space = 4; // The space between the squares
    for (int i = 0; i < board.length / 3; i += 2) {
      // Switches between the 2 top corners
      bool complete = false;
      for (int j = i + space; j < board.length - i * space / 2; j += space) {
        // Iterates through the diagonals, first round the space is 4, then 2 (0-4-8, then 2-4-6)
        complete =
            board[i].player != null && board[i].player == board[j].player;
        if (!complete) {
          break;
        }
      }
      if (complete) {
        return true;
      }
      space = 2; // half on the second iteration
    }
    return false;
  }

  /// Saves the data to the local-storage, if [won] also updates "games-won"
  static Future<void> setData(bool won, Stopwatch time,
      {String? gamesPlayed, String? gamesWon, String? timePlayed}) async {
    final prefs = await SharedPreferences.getInstance();

    if (gamesPlayed != null) {
      prefs.setInt(gamesPlayed, (prefs.getInt(gamesPlayed) ?? 0) + 1);
    }
    if (timePlayed != null) {
      prefs.setInt(
          timePlayed, (prefs.getInt(timePlayed) ?? 0) + time.elapsed.inSeconds);
    }
    if (gamesWon != null && won) {
      prefs.setInt(gamesWon, (prefs.getInt(gamesWon) ?? 0) + 1);
    }
  }

  static void switchTurn(Player one, Player two) {
    one.isTurn = !one.isTurn;
    two.isTurn = !two.isTurn;
  }
}
