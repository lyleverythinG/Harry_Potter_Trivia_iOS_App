//
//  Constants.swift
//  Harry_Potter_Trivia_iOS_App
//
//  Created by Lyle Dane Carcedo on 12/17/24.
//

import Foundation
import SwiftUI

struct InfoBackgroundImage: View {
    var body: some View {
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

enum Constants {
    static let hpFont = "PartyLetPlain"
}

extension Button {
    func doneButton() -> some View {
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundStyle(.white)
    }
}
