//
//  HeroDetailView.swift
//  HeroRandomizer
//
//  Created by Alikhan Kassiman on 2025.03.07.
//

import SwiftUI

struct HeroDetailView: View {
    let hero: Superhero
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: hero.images.lg)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 250)
                    }
                }
                
                Group {
                    detailSection(title: "Biography") {
                        infoRow(label: "Full Name", value: hero.biography.fullName)
                        infoRow(label: "Alter Egos", value: hero.biography.alterEgos)
                        infoRow(label: "Aliases", value: hero.biography.aliases.joined(separator: ", "))
                        infoRow(label: "Place of Birth", value: hero.biography.placeOfBirth)
                        infoRow(label: "First Appearance", value: hero.biography.firstAppearance)
                        infoRow(label: "Publisher", value: hero.biography.publisher ?? "Unknown")
                        infoRow(label: "Alignment", value: hero.biography.alignment)
                    }
                    
                    detailSection(title: "Power Stats") {
                        infoRow(label: "Intelligence", value: "\(hero.powerstats.intelligence)")
                        infoRow(label: "Strength", value: "\(hero.powerstats.strength)")
                        infoRow(label: "Speed", value: "\(hero.powerstats.speed)")
                        infoRow(label: "Durability", value: "\(hero.powerstats.durability)")
                        infoRow(label: "Power", value: "\(hero.powerstats.power)")
                        infoRow(label: "Combat", value: "\(hero.powerstats.combat)")
                    }
                    
                    detailSection(title: "Appearance") {
                        infoRow(label: "Gender", value: hero.appearance.gender)
                        infoRow(label: "Race", value: hero.appearance.race ?? "Unknown")
                        infoRow(label: "Height", value: hero.appearance.height.joined(separator: ", "))
                        infoRow(label: "Weight", value: hero.appearance.weight.joined(separator: ", "))
                        infoRow(label: "Eye Color", value: hero.appearance.eyeColor)
                        infoRow(label: "Hair Color", value: hero.appearance.hairColor)
                    }
                    
                    detailSection(title: "Work") {
                        infoRow(label: "Occupation", value: hero.work.occupation)
                        infoRow(label: "Base", value: hero.work.base)
                    }
                    
                    detailSection(title: "Connections") {
                        infoRow(label: "Group Affiliation", value: hero.connections.groupAffiliation)
                        infoRow(label: "Relatives", value: hero.connections.relatives)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(hero.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(#colorLiteral(red: 0.9529411793, green: 0.9529411793, blue: 0.9529411793, alpha: 1)))
    }
    
    private func detailSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value.isEmpty ? "Unknown" : value)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}
