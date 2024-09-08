import UIKit

final class TicTacToeView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var boardCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Const.boardCellReuseIdentifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var winnerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Const.resetButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            boardCollectionView, winnerLabel, resetButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let viewModel: any TicTacToeViewModelProtocol
    
    // MARK: - Initializers
    
    init(viewModel: any TicTacToeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupAppearance()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Static Methods
    
    static func create() -> TicTacToeView {
        let model = Game()
        let viewModel = TicTacToeViewModel(model: model)
        let view = TicTacToeView(viewModel: viewModel)
        return view
    }
}

// MARK: - Private Methods

private extension TicTacToeView {
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / 3.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.zero
        section.interGroupSpacing = .zero
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setupAppearance() {
        setupScrollView()
        setupStackView()
        setupBoardCollectionView()
    }
    
    func setupScrollView() {
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupStackView() {
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupBoardCollectionView() {
        NSLayoutConstraint.activate([
            boardCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            boardCollectionView.heightAnchor.constraint(equalTo: boardCollectionView.widthAnchor)
        ])
    }
    
    func updateUI(for state: GameState) {
        let isInProgress = state == .inProgress
        winnerLabel.isHidden = isInProgress
        resetButton.isHidden = isInProgress
        
        winnerLabel.text = {
            switch state {
            case .inProgress: nil
            case .won(let player): player + Const.winningResult
            case .draw: Const.drawResult
            }
        }()
    }
    
    func bindViewModel() {
        viewModel.boardSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.boardCollectionView.reloadData()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.gameStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateUI(for: state)
            }
            .store(in: &viewModel.cancellables)
    }
    
    @objc func resetButtonTapped() {
        viewModel.resetGame()
    }
}

// MARK: - Methods

extension TicTacToeView {
    
    func configure(
        with backgroundColor: UIColor,
        textColor: UIColor,
        textFont: UIFont
    ) {
        self.backgroundColor = backgroundColor
        resetButton.tintColor = textColor
        winnerLabel.font = textFont
    }
}

// MARK: - UICollectionViewDataSource Methods

extension TicTacToeView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.boardCellReuseIdentifier, for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        let board = viewModel.boardSubject.value
        cell.contentView.backgroundColor = .white
        
        if let player = board[indexPath.row][indexPath.section].player {
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            let label = createPlayerLabel(for: player)
            cell.contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        } else {
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        }
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
    }
    
    private func createPlayerLabel(for player: String) -> UILabel {
        let label = UILabel()
        label.text = player
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

// MARK: - UICollectionViewDelegate Methods

extension TicTacToeView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.makeMove(at: indexPath)
    }
}
