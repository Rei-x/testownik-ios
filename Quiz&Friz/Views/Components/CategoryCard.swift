//
//  SubjectCard.swift
//  Quiz&Friz
//
//  Created by Solvro on 30/12/2024.
//

import SwiftUI

struct CategoryCard: View {
    let title: String
    let iconName: String
  
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: iconName)
                .font(.system(size: 30))
                .foregroundColor(.black)
            
            Text(title)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: 140)
        .frame(height: 100)
        .padding()
        .background(Color(.buttonLight))
        .cornerRadius(8)
    }
}
