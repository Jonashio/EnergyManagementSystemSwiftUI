//
//  LoadingView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 5/8/22.
//

import SwiftUI

struct LoadingView: View {
    
    var alpha: Double = 0
    
    var body: some View {
        VStack {
            LottieView(name: "electricity-charging")
                .frame(width: 100, height: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "000000", alpha: alpha))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
