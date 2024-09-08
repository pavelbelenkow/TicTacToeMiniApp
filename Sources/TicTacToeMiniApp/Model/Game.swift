import Foundation

struct Game {
    
    // MARK: - Properties
    
    var board: [[TicTacToeCell]]
    var currentPlayer: String
    var state: GameState
    
    // MARK: - Initializers
    
    init() {
        board = Array(repeating: Array(repeating: TicTacToeCell(player: nil), count: 3), count: 3)
        currentPlayer = Const.crossesPlayer
        state = .inProgress
    }
}

// MARK: - Private Methods

private extension Game {
    
    func checkWinner(for player: String) -> Bool {
        Const.winningCombinations.contains { combination in
            combination.allSatisfy { row, col in
                board[row][col].player == player
            }
        }
    }
}

// MARK: - Methods

extension Game {
    
    mutating func makeMove(at indexPath: IndexPath) -> Bool {
        guard state == .inProgress else { return false }
        guard board[indexPath.row][indexPath.section].player == nil else { return false }
        
        board[indexPath.row][indexPath.section].player = currentPlayer
        
        if checkWinner(for: currentPlayer) {
            state = .won(player: currentPlayer)
        } else if board.flatMap({ $0 }).allSatisfy({ $0.player != nil }) {
            state = .draw
        } else {
            currentPlayer = (currentPlayer == Const.crossesPlayer) ? Const.noughtsPlayer : Const.crossesPlayer
        }
        
        return true
    }
    
    mutating func reset() {
        board = Array(repeating: Array(repeating: TicTacToeCell(player: nil), count: 3), count: 3)
        currentPlayer = Const.crossesPlayer
        state = .inProgress
    }
}
