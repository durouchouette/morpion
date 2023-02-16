//
//  ContentView.swift
//  Morpion
//
//  Created by Elodie Cari on 2/16/23.
//

import SwiftUI

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State private var plays: [Play?] = Array(repeating: nil, count: 9)
    @State private var isBoardDisabled: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.blue).opacity(0.6)
                                .frame(width: geometry.size.width/3 - 15, height:geometry.size.width/3 - 15)
                            
                            Image(systemName: plays[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .onTapGesture {
                            // if there is already a play there, don't do anything
                            if isSpaceOccupied(in: plays, forIndex: i) { return }
                            
                            plays[i] = Play(player:. human, boardIndex: i)
                            isBoardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = chooseComputerPlayPosition(in: plays)
                                plays[computerPosition] = Play(player: .computer, boardIndex: computerPosition)
                                isBoardDisabled = false
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isBoardDisabled)
            .padding()
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
}

enum Player {
    case human, computer
}

struct Play {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
