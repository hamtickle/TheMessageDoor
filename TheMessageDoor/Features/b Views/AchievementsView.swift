//
//  AchievementsView.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/16/25.
//

import SwiftUI

struct AchievementsView: View {
    var body: some View {
        ZStack (alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .center) {
                
                Text("Achievements")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                
                Text("Coming Soon")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 10)
                    .padding(.top, 30)
                
                Image(systemName: "trophy")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.top, 50)
            }
            
                
        
        }
       
       
    }
}

#Preview {
    AchievementsView()
}
