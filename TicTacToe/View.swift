//
//  ViewController.swift
//  TicTacToe
//
//  Created by Алексей Гончаров on 4/13/22.
//

import UIKit

class View: UIViewController {
    
    var controller: Controller? 
    
    let crossVictories: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    let nullVictories: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    enum Colors {
        case initial
        case cross
        case null
        case winner
        
        var color: UIColor {
            switch self {
            case .initial:
                return .black
            case .cross:
                return .orange
            case .null:
                return .systemMint
            case .winner:
                return .systemGreen
            }
        }
    }
    //MARK: - Gamefield
    @IBOutlet var pads: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setUpLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controller?.onViewAppear()
    }
    //MARK: - SetupViews
    func setupViews() {
        view.addSubview(nullVictories)
        view.addSubview(crossVictories)
        
    }
    //MARK: - SetupLayout
    func setUpLayout() {
        crossVictories.translatesAutoresizingMaskIntoConstraints = false
        nullVictories.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            crossVictories.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            crossVictories.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            
            nullVictories.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nullVictories.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
    }
    
    //MARK: - Methods
    @IBAction func didPressCell(_ sender: UIButton) {
        guard let index = pads.firstIndex(of: sender) else {
            return
        }
        controller?.didPressOnCell(index: index)
    }
    
    func updateCross(score: Int) {
        crossVictories.text = "Крестик: \(score)"
    }
    
    func updateNought(score: Int) {
        nullVictories.text = "Нолик: \(score)"
    }
    
    func updateCell(index: Int, player: String) {
        let cell = pads[index]
        cell.setAttributedTitle(NSAttributedString(string: player, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 48, weight: .bold)]), for: .normal)
        cell.backgroundColor = player == "X" ? Colors.cross.color : Colors.null.color
    }
    
    func highlightWinnerCells(indices: [Int]) {
        indices.forEach { index in
            pads[index].transform = .init(scaleX: 1.1, y: 1.1)
            pads[index].backgroundColor = Colors.winner.color
            pads[index].layer.zPosition = 1000
        }
    }
    
    func reset() {
        self.pads.forEach { button in
            button.setAttributedTitle(NSAttributedString(string: " "), for: .normal)
            button.backgroundColor = Colors.initial.color
            button.transform = .identity
        }
    }
}


