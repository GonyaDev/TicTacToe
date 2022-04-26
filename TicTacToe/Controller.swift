//
//  Controller.swift
//  TicTacToe
//
//  Created by Алексей Гончаров on 4/22/22.
//

import Foundation
import UIKit

class Controller {
    
    //MARK: - Router
    private let router: Router
    
    //MARK: - View
    weak var view: View?
    
    //MARK: - Gamefield
    var gameField = Array(repeating: [" ", " ", " "], count: 3)
    typealias Gamefield = [[String]]

    //MARK: - Players
    var player = ""
    var previousPlayer = ""
    
    //MARK: - Counters
    var crossWinCount: Int = 0 {
        didSet {
            view?.updateCross(score: crossWinCount)
        }
    }
    var nullWinCount: Int = 0 {
        didSet {
            view?.updateNought(score: nullWinCount)
        }
    }
    
    //MARK: - Initializers
    init(router: Router, view: View) {
        self.router = router
        self.view = view
    }
    
    //MARK: - ViewLifecycle
    func onViewAppear() {
        view?.updateNought(score: 0)
        view?.updateCross(score: 0)
        resetGame()
        askPlayer()
        
    }
    
    //MARK: - Game Logic
    func askPlayer() {
        router.showAlert(title: "Выберите крестик либо нолик", message: " ", actions: [
            UIAlertAction(title: "Крестик", style: .default, handler: { _ in
                self.player = "X"
            }),
            UIAlertAction(title: "Нолик", style: .destructive, handler: { _ in
                self.player = "O"
            }),
        ])
    }
    
    //MARK: - Action
    func didPressOnCell(index: Int) {
        let x = index / gameField.count
        let y = index % gameField.count
        guard gameField[x][y] == " " else {
            return
        }
        gameField[x][y] = player
        view?.updateCell(index: index, player: player)
        
        let noEmptyCellsCount = gameField.reduce(0) { partialResult, line in
            return partialResult + line.reduce(0, { linePartialResult, cell in
                cell == " " ? linePartialResult : linePartialResult + 1
            })
        }
        
        //Ничья
        if noEmptyCellsCount == 9 {
            router.showAlert(title: "Ничья!", message: " ", actions: [UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                self.resetGame()
            })])
            return
        }
        
        if let winnerCoordinates = isGameContinued(gameField: gameField, currentPlayer: player) {
            
            if player == "X" {
                crossWinCount += 1
            } else {
               nullWinCount += 1
            }
            
            router.showAlert(title: "Ты победил \(player)!", message: " ", actions: [UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                self.resetGame()
            })])
            
            let indices = winnerCoordinates.map { coordinates in
                coordinates.1 * gameField.count + coordinates.0
            }
            
            view?.highlightWinnerCells(indices: indices)
            return
        }
        player = player == "X" ? "O" : "X"
    }
    
    func isGameContinued(gameField: Gamefield, currentPlayer: String) -> [(Int, Int)]? {
        //Перечисляем все варианты
        let variant1 = [
            [currentPlayer, currentPlayer, currentPlayer],
            [" ", " ", " "],
            [" ", " ", " "]
        ]

        let variant2 = [
            [" ", " ", " "],
            [currentPlayer, currentPlayer, currentPlayer],
            [" ", " ", " "]
        ]

        let variant3 = [
            [" ", " ", " "],
            [" ", " ", " "],
            [currentPlayer, currentPlayer, currentPlayer]
        ]

        let variant4 = [
            [currentPlayer, " ", " "],
            [currentPlayer, " ", " "],
            [currentPlayer, " ", " "]
        ]

        let variant5 = [
            [" ", currentPlayer, " "],
            [" ", currentPlayer, " "],
            [" ", currentPlayer, " "]
        ]

        let variant6 = [
            [" ", " ", currentPlayer],
            [" ", " ", currentPlayer],
            [" ", " ", currentPlayer]
        ]

        let variant7 = [
            [currentPlayer, " ", " "],
            [" ", currentPlayer, " "],
            [" ", " ", currentPlayer]
        ]

        let variant8 = [
            [" ", " ", currentPlayer],
            [" ", currentPlayer, " "],
            [currentPlayer, " ", " "]
        ]
        // Складываем все варианты в константу
        let allVariants = [variant1, variant2, variant3, variant4, variant5, variant6, variant7, variant8]
        for currentVariant in allVariants {
            //Кординаты
            var coordinates = [(Int, Int)]()
            for y in 0..<currentVariant.count {
                for x in 0..<currentVariant[y].count {
                    let cell = currentVariant[y][x]
                    if cell == currentPlayer {
                        coordinates.append((x, y))
                    }
                }
            }
            var winnerCoordinates = [(Int, Int)]()
            for coordinate in coordinates {
                let cell = gameField[coordinate.1][coordinate.0]
                if cell == currentPlayer {
                    winnerCoordinates.append(coordinate)
                } else {
                    break
                }
                if winnerCoordinates.count == 3 {
                    return winnerCoordinates
                }
            }
        }
        return nil
    }
    
    //MARK: RESET
    func resetGame() {
        self.gameField = Array(repeating: [" ", " ", " "], count: 3)
        view?.reset()
    }
}
