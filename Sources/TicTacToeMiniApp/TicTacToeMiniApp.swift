import UIKit
import MiniAppCore

public final class TicTacToeMiniApp: MiniAppProtocol {
    
    // MARK: - Public Properties
    
    public var title: String = Const.miniAppTitle
    
    public var icon: UIImage = UIImage(systemName: Const.miniAppIcon) ?? UIImage()
    
    public private(set) var view: UIView = TicTacToeView.create()
    
    // MARK: - Public Initializers
    
    public init() {}
    
    // MARK: - Public Methods
    
    public func configure(with configuration: MiniAppConfiguration) {
        if let ticTacToeView = view as? TicTacToeView {
            ticTacToeView.configure(
                with: configuration.backgroundColor,
                textColor: configuration.textColor,
                textFont: configuration.font
            )
        }
    }
}
