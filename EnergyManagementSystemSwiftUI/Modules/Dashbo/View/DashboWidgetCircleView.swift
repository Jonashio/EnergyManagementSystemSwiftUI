//
//  DashboWidgetCircleView.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 5/8/22.
//

import SwiftUI

struct DashboWidgetCircleView: View {
    
    private let customID = UUID()
    @State private var isSelected: Bool = false
    @State var textTitle: String = "Test title"
    
    @Binding var value: Float
    @Binding var selectedID: UUID
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(amount: value * 100))
                .shadow(color: .black, radius: 5, x: 5, y: 5)
                .scaleEffect(isSelected ? 1.2 : 1)
            
            Circle()
                .stroke(Color.gray, lineWidth: 2)
                .scaleEffect(isSelected ? 1.2 : 1)
                
            VStack(spacing: 5) {
                Text(textTitle)
                    .font(Font.system(.body))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.01)
                if isSelected {
                    Text("\(value.clean) KWh")
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                }
            }
            .scaleEffect(isSelected ? 1.05 : 1)
            .frame(alignment: .center)
        }
        .frame(width: 120, height: 120)
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
}

struct DashboWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DashboWidgetCircleView(value: .constant(50.4), selectedID: .constant(UUID()))
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Main preview")
    }
}
