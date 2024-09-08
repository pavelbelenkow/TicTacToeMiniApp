import Foundation
import Combine

// MARK: - Protocols

protocol TicTacToeViewModelProtocol: ObservableObject {
    var boardSubject: CurrentValueSubject<[[TicTacToeCell]], Never> { get }
    var currentPlayerSubject: CurrentValueSubject<String, Never> { get }
    var gameStateSubject: CurrentValueSubject<GameState, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    
    func makeMove(at indexPath: IndexPath)
    func resetGame()
}

final class TicTacToeViewModel: TicTacToeViewModelProtocol {
    
    // MARK: - Subject Properties
    
    private(set) var boardSubject: CurrentValueSubject<[[TicTacToeCell]], Never>
    private(set) var currentPlayerSubject: CurrentValueSubject<String, Never>
    private(set) var gameStateSubject: CurrentValueSubject<GameState, Never>
    
    // MARK: - Private Properties
    
    private var model: Game
    
    // MARK: - Properties
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init(model: Game) {
        self.model = model
        self.boardSubject = CurrentValueSubject(model.board)
        self.currentPlayerSubject = CurrentValueSubject(model.currentPlayer)
        self.gameStateSubject = CurrentValueSubject(model.state)
    }
    
    // MARK: - Deinitializers
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Private Methods

private extension TicTacToeViewModel {
    
    func updateSubjects() {
        boardSubject.send(model.board)
        currentPlayerSubject.send(model.currentPlayer)
        gameStateSubject.send(model.state)
    }
}

// MARK: - Methods

extension TicTacToeViewModel {
    
    func makeMove(at indexPath: IndexPath) {
        guard model.makeMove(at: indexPath) else { return }
        updateSubjects()
    }
    
    func resetGame() {
        model.reset()
        updateSubjects()
    }
}
