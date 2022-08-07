//
//  DashboPercentageSourceView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 7/8/22.
//

import SwiftUI

struct DashboPercentageSourceView: View {
    private let customID = UUID()
    @State private var isSelected: Bool = false
    
    @Binding var data: DashboWidgetRectangleData
    @Binding var selectedID: UUID
    var action: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                ProgressView("Solar", value: getValue(data.solar), total: data.demand)
                    .font(Font.system(.body))
                    .foregroundColor(.black)
                    .accentColor(data.solar > 0 ? .accentColor : .red)
                    .progressViewStyle(LinearProgressViewStyle())
                ProgressView("Grid", value: getValue(data.grid), total: data.demand)
                    .font(Font.system(.body))
                    .foregroundColor(.black)
                    .accentColor(data.grid > 0 ? .accentColor : .red)
                    .progressViewStyle(LinearProgressViewStyle())
                ProgressView("Quasar", value: getValue(data.quasar), total: data.demand)
                    .font(Font.system(.body))
                    .foregroundColor(.black)
                    .accentColor(data.quasar > 0 ? .accentColor : .red)
                    .progressViewStyle(LinearProgressViewStyle())
            }
            .frame(alignment: .center)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black, radius: 5, x: 5, y: 5)
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
            action?()
        }
    }
    
    func getValue(_ value: Double) -> Double {
        return value > 0 ? value : (-1 * value)
    }
}

struct DashboPercentageSourceView_Previews: PreviewProvider {
    @State static var data: DashboWidgetRectangleData = (demand: 100,
                                                         solar: 30,
                                                         grid: 20,
                                                         quasar: 45)
    @State static var selectedID = UUID()
    
    static var previews: some View {
        DashboPercentageSourceView(data: $data, selectedID: $selectedID)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Main preview")
    }
}
