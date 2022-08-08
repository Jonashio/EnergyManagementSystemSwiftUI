//
//  DashboSourceAndDemandView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 7/8/22.
//

import SwiftUI

typealias DashboWidgetRectangleData = (demand: Double, solar: Double, grid: Double, quasar: Double)

struct DashboSourceAndDemandView: View {
    private let customID = UUID()
    @State private var isSelected: Bool = false
    
    @Binding var data: DashboWidgetRectangleData
    @Binding var selectedID: UUID
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.cyan)
                .shadow(color: .gray, radius: 5, x: 5, y: 5)
            
            VStack(spacing: 0) {
                HStack(spacing: 5) {
                    Text(getTitle())
                        .font(Font.system(.body))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.01)
                }
                
                if isSelected {
                    Divider()
                        .padding(.vertical, 5)
                    
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
            }
            .frame(alignment: .center)
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: isSelected ? 160 : 60, maxHeight: isSelected ? 160 : 60)
        .onChange(of: selectedID, perform: { newValue in
            if newValue != customID {
                withAnimation(.interpolatingSpring(stiffness: 850, damping: 15)) {
                    isSelected = false
                }
            }
        })
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 850, damping: 15)) {
                isSelected = true
                selectedID = customID
            }
        }
    }
    
    func getTitle() -> String {
        if isSelected {
            return "The building demand \(data.demand.clean) KWh"
        } else {
            return "Source of energy / Building demand"
        }
    }
}

struct DashboSourceAndDemandView_Previews: PreviewProvider {
    @State static var data: DashboWidgetRectangleData = (demand: 200,
                                                         solar: 60,
                                                         grid: 100,
                                                         quasar: 140)
    @State static var selectedID = UUID()
    
    static var previews: some View {
        DashboSourceAndDemandView(data: $data, selectedID: $selectedID)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Main preview")
    }
}
