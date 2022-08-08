//
//  ErrorView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 9/8/22.
//

import SwiftUI

struct ErrorView: View {
    var action: (() -> Void)?
    var body: some View {
        VStack {
            VStack {
                Text("Error")
                    .font(.system(.title2))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
                    .padding(EdgeInsets(top: 30, leading: 15, bottom: 0, trailing: 15))
                Text("An error has occurred.")
                    .font(.system(.body))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 30, trailing: 15))
                
                Button(action: {
                    action?()
                }) {
                    Text("Try again")
                }.padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(25)
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(hex: "000000", alpha: 0.5))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
            .previewDisplayName("Main preview")
    }
}
