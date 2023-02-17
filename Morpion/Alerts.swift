//
//  Alerts.swift
//  Morpion
//
//  Created by Elodie Cari on 2/16/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(
        title: Text("You win!"),
        message: Text("Good Job!"),
        buttonTitle: Text("Let's play again!"))
    
    static let computerWin = AlertItem(
        title: Text("You lost!"),
        message: Text("The AI wins!!!"),
        buttonTitle: Text("Oh no, let's try again"))
    
    static let draw = AlertItem(
        title: Text("All done"),
        message: Text("This is full, you need to draw!"),
        buttonTitle: Text("Let's try again!"))
}
