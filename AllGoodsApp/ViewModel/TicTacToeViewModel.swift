//
//  TicTacToeViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import Foundation

class TicTacToeViewModel: ObservableObject {
    @Published var board: [[Character?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @Published var player: Character = "X"
    @Published var tries = 0
    @Published var winner: Character? = nil
    @Published var isGameOver = false
    @Published var showPromo = false
    var username: String?

    var onGameEnded: (() -> Void)?
    var onPromoDismissed: (() -> Void)?

    init(username: String?) {
        self.username = username
    }

    func handlePlayerMove(row: Int, col: Int) {
        if board[row][col] == nil && player == "X" {
            board[row][col] = player
            tries += 1
            winner = checkWinner(board: board)
            if winner != nil {
                if winner == "X" {
                    showPromo = true
                } else {
                    isGameOver = true
                }
            } else if tries == 9 {
                isGameOver = true
            } else {
                player = "O"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.playComputer()
                }
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
            board[i][j] = "O"
            tries += 1
            winner = checkWinner(board: board)
            if winner != nil {
                isGameOver = true
            } else if tries == 9 {
                isGameOver = true
            } else {
                player = "X"
            }
        }
    }

    func resetGame() {
        player = "X"
        tries = 0
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        isGameOver = false
        showPromo = false
        winner = nil
    }

    func checkWinner(board: [[Character?]]) -> Character? {
        // Check rows
        for row in board {
            if let marker = row[0], row[1] == marker, row[2] == marker {
                return marker
            }
        }

        // Check columns
        for col in 0..<3 {
            if let marker = board[0][col], board[1][col] == marker, board[2][col] == marker {
                return marker
            }
        }

        // Check diagonals
        if let marker = board[0][0], board[1][1] == marker, board[2][2] == marker {
            return marker
        }
        if let marker = board[0][2], board[1][1] == marker, board[2][0] == marker {
            return marker
        }

        // Check for draw scenario (no winner and all lines have different markers)
        let allMarkers = board.flatMap { $0.compactMap { $0 } }
        if allMarkers.count == 9 && Set(allMarkers).count == 2 {
            return nil // Return nil for draw
        }

        return nil
    }
}
