//
//  DashboWidgetRectangleView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 5/8/22.
//

import SwiftUI

typealias DashboWidgetRectangleData = (totalValue: Float, solar: Float, grid: Float, quasar: Float)

struct DashboWidgetRectangleView: View {
    
    private let customID = UUID()
    @Binding var data: DashboWidgetRectangleData
    var action: (() -> Void)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.cyan)
                .shadow(color: .black, radius: 5, x: 5, y: 5)
            
            VStack(spacing: 5) {
                HStack(spacing: 5) {
                    Text("The building demand \(data.totalValue.clean) KWh")
                        .font(Font.system(.body))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.01)
                }
                
                Divider()
                
                HStack(spacing: 5) {
                    VStack {
                        Text("SOLAR")
                            .font(Font.system(.body))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.01)
                        Text("\(data.solar.clean) KWh")
                            .font(Font.system(.body))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.01)
                            
                    }
                    .frame(maxHeight: .infinity)
                    .rotationEffect(.degrees(90))
                    Spacer()
                    VStack {
                        Text("GRID")
                            .font(Font.system(.body))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.01)
                        Text("\(data.grid.clean) KWh")
                            .font(Font.system(.body))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.01)
                            
                    }
                    .frame(maxHeight: .infinity)
                    .rotationEffect(.degrees(90))
                    Spacer()
                    VStack {
                        Text("QUASAR")
                            .font(Font.system(.body))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.01)
                        Text("\(data.quasar.clean) KWh")
                            .font(Font.system(.body))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.01)
                            
                    }
                    .frame(maxHeight: .infinity)
                    .rotationEffect(.degrees(90))
                }
            }
            .frame(alignment: .center)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 160)
        .onTapGesture {
            action()
        }
    }
}

struct DashboWidgetRectangleView_Previews: PreviewProvider {
    @State static var data: DashboWidgetRectangleData = (totalValue: 200, solar: 60, grid: 100, quasar: 140)
    static var previews: some View {
        DashboWidgetRectangleView(data: $data) {}
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Main preview")
    }
}
