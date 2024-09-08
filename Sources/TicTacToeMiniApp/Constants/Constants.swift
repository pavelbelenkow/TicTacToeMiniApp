import Foundation

// MARK: - Constants

enum Const {
    static let miniAppTitle = "Tic-Tac-Toe"
    static let miniAppIcon = "gamecontroller"
    static let crossesPlayer = "X"
    static let noughtsPlayer = "O"
    static let boardCellReuseIdentifier = "boardCell"
    static let resetButtonTitle = "Restart Game"
    static let winningResult = "'s Wins!"
    static let drawResult = "It's a Draw!"
    
    static let winningCombinations = [
        [(0, 0), (0, 1), (0, 2)],
        [(1, 0), (1, 1), (1, 2)],
        [(2, 0), (2, 1), (2, 2)],
        [(0, 0), (1, 0), (2, 0)],
        [(0, 1), (1, 1), (2, 1)],
        [(0, 2), (1, 2), (2, 2)],
        [(0, 0), (1, 1), (2, 2)],
        [(0, 2), (1, 1), (2, 0)]
    ]
}
