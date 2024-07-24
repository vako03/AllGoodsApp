//
//  TicTacToeViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import Foundation
import SwiftUI

class TicTacToeViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var board: [[Character?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @Published var player: Character = "X"
    @Published var tries = 0
    @Published var winner: Character? = nil
    @Published var isGameOver = false
    @Published var showPromo = false
    @Published var alertItem: AlertItem?
    var username: String?
    
    var onGameEnded: (() -> Void)?
    var onPromoDismissed: (() -> Void)?
    
    // MARK: - Initialization
    init(username: String?) {
        self.username = username
    }
    
    // MARK: - Game Handling
    func handlePlayerMove(row: Int, col: Int) {
        makeMove(row: row, col: col)
        if player == "O" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.playComputer()
            }
        }
    }
    
    private func makeMove(row: Int, col: Int) {
        if board[row][col] == nil {
            board[row][col] = player
            tries += 1
            winner = checkWinner(board: board)
            if winner != nil {
                isGameOver = true
                if winner == "X" {
                    showPromo = true
                }
                updateAlertItem()
            } else if tries == 9 {
                isGameOver = true
                updateAlertItem()
            } else {
                player = (player == "X") ? "O" : "X"
            }
        }
    }
    
    func playComputer() {
        let emptyTiles = board.enumerated().flatMap { (i, row) in
            row.enumerated().compactMap { (j, tile) in
                tile == nil ? (i, j) : nil
            }
        }
        
        if let (i, j) = emptyTiles.randomElement() {
            makeMove(row: i, col: j)
        }
    }
    
    func resetGame() {
        player = "X"
        tries = 0
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        isGameOver = false
        showPromo = false
        winner = nil
        alertItem = nil
    }
    
    func updateAlertItem() {
        if showPromo {
            alertItem = AlertItem(
                title: "Congratulations!",
                message: "You've won! Use promo code GET10.",
                primaryButton: .default(Text("Copy Code"), action: {
                    UIPasteboard.general.string = "Get10"
                    self.onPromoDismissed?()
                }),
                secondaryButton: .default(Text("OK"), action: self.onPromoDismissed)
            )
        } else if isGameOver {
            alertItem = AlertItem(
                title: "Game Over",
                message: {
                    if winner == nil {
                        return "It's a draw. Try again or cancel."
                    } else if winner == "O" {
                        return "\(username ?? "Player") didn't win. Try again or cancel."
                    } else {
                        return "\(String(winner!)) won"
                    }
                }(),
                primaryButton: .default(Text("Try Again"), action: resetGame),
                secondaryButton: .cancel(Text("Cancel"), action: onGameEnded)
            )
        }
    }
    
    func checkWinner(board: [[Character?]]) -> Character? {
        for row in board {
            if let marker = row[0], row[1] == marker, row[2] == marker {
                return marker
            }
        }
        
        for col in 0..<3 {
            if let marker = board[0][col], board[1][col] == marker, board[2][col] == marker {
                return marker
            }
        }
        
        if let marker = board[0][0], board[1][1] == marker, board[2][2] == marker {
            return marker
        }
        if let marker = board[0][2], board[1][1] == marker, board[2][0] == marker {
            return marker
        }
        
        let allMarkers = board.flatMap { $0.compactMap { $0 } }
        if allMarkers.count == 9 {
            return nil
        }
        
        return nil
    }
}

// MARK: - Alert Item
struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryButton: Alert.Button
    let secondaryButton: Alert.Button
}
