import Foundation

// MARK: - Game State Enum

enum GameState: Equatable {
    case inProgress
    case won(player: String)
    case draw
}
