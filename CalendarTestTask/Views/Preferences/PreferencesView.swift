//
//  PreferencesView.swift
//  CalendarTestTask
//
//  Created by Andrey Efimov on 15.12.2025.
//

import SwiftUI

struct PreferencesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        NavigationStack {
            Form {
                Section(header: sectionHeader("Appearance")) {
                    themeAppearence
                }
            }
        }
        .navigationTitle("Preferences")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(Color.mycolor.myAccent)
                        .frame(width: 30, height: 30)
                        .background(.black.opacity(0.001))
                }
            }
        }
        .preferredColorScheme(coordinator.selectedTheme.colorScheme)

    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(Color.mycolor.myAccent)
    }

    private var themeAppearence: some View {
        UnderlineSermentedPickerNotOptional(
            selection: $coordinator.selectedTheme,
            allItems: Theme.allCases,
            titleForCase: { $0.displayName },
            selectedFont: .footnote
        )
    }

}

#Preview {
    NavigationStack {
        PreferencesView()
            .environmentObject(AppCoordinator())
    }
}
