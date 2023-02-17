//
//  GameViewModel.swift
//  Morpion
//
//  Created by Elodie Cari on 2/16/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var plays: [Play?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled: Bool = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for i: Int) {
        // if there is already a play there, don't do anything
        if isSpaceOccupied(in: plays, forIndex: i) { return }
        
        plays[i] = Play(player:. human, boardIndex: i)
   
        if checkWinCondition(for: .human, in: plays) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: plays) {
            alertItem = AlertContext.draw
            return
        }
        
        isBoardDisabled = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = chooseComputerPlayPosition(in: plays)
            plays[computerPosition] = Play(player: .computer, boardIndex: computerPosition)
            isBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: plays) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDraw(in: plays) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSpaceOccupied(in plays: [Play?], forIndex index: Int) -> Bool {
        return plays.contains(where: {$0?.boardIndex == index})
    }
    
    func chooseComputerPlayPosition(in plays: [Play?]) -> Int {
        var playPosition = Int.random(in: 0..<9)
        while isSpaceOccupied(in: plays, forIndex: playPosition) {
            playPosition = Int.random(in: 0..<9)
        }
        
        return playPosition
    }
    
    func checkWinCondition(for player: Player, in plays: [Play?]) -> Bool {
        // Every win patterns possible
        let winPatterns: Set<Set<Int>> =
            [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        // remove all the nils and get human or computer moves
        let playerMoves = plays.compactMap { $0 }.filter { $0.player == player }
        
        // Getting all the indexes of the positions where the player played
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
       
        // the win condition pattern is a subset of the player positions
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func checkForDraw(in plays: [Play?]) -> Bool {
        return plays.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        plays = Array(repeating: nil, count: 9)
    }
}
