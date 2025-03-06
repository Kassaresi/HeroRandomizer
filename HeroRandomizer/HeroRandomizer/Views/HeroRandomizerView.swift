//
//  HeroRandomizerView.swift
//  HeroRandomizer
//
//  Created by Alikhan Kassiman on 2025.03.07.
//

import SwiftUI
import Combine

class HeroViewModel: ObservableObject {
    @Published var currentHero: Superhero?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var allHeroes: [Superhero] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadAllHeroes()
    }
    
    func loadAllHeroes() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.fetchAllHeroes()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.description
                }
            }, receiveValue: { [weak self] heroes in
                self?.allHeroes = heroes
                self?.getRandomHero()
            })
            .store(in: &cancellables)
    }
    
    func getRandomHero() {
        guard !allHeroes.isEmpty else { return }
        currentHero = allHeroes.randomElement()
    }
}

struct HeroRandomizerView: View {
    @StateObject private var viewModel = HeroViewModel()
    @State private var showingDetailView = false
    
    private let backgroundColor = Color(#colorLiteral(red: 0.9529411793, green: 0.9529411793, blue: 0.9529411793, alpha: 1))
    private let cardColor = Color.white
    private let accentColor = Color.blue
    private let textColor = Color.black
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                            .padding(.top, 8)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Try Again") {
                            viewModel.loadAllHeroes()
                        }
                        .padding()
                        .background(accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if let hero = viewModel.currentHero {
                                heroCard(hero: hero)
                                    .padding(.horizontal)
                                
                                HStack(spacing: 16) {
                                    Button("View Details") {
                                        showingDetailView = true
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    
                                    Button("Random Hero") {
                                        viewModel.getRandomHero()
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                }
                                .padding(.horizontal)
                            } else {
                                VStack(spacing: 16) {
                                    Text("Welcome to Hero Randomizer")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("Press the button to discover a random superhero")
                                        .foregroundColor(.secondary)
                                    
                                    Button("Get Started") {
                                        viewModel.getRandomHero()
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                }
                                .padding()
                            }
                        }
                        .padding(.vertical)
                        .background(
                            NavigationLink(
                                destination: Group {
                                    if let hero = viewModel.currentHero {
                                        HeroDetailView(hero: hero)
                                    }
                                },
                                isActive: $showingDetailView
                            ) {
                                EmptyView()
                            }
                        )
                    }
                }
            }
            .navigationTitle("Hero Randomizer")
        }
    }
    
    private func heroCard(hero: Superhero) -> some View {
        VStack(alignment: .leading, spacing: 0) {
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
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(hero.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if !hero.biography.fullName.isEmpty {
                    Text(hero.biography.fullName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                Text("Power Stats")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                statBar(label: "Intelligence", value: hero.powerstats.intelligence)
                statBar(label: "Strength", value: hero.powerstats.strength)
                statBar(label: "Speed", value: hero.powerstats.speed)
                statBar(label: "Durability", value: hero.powerstats.durability)
                
                Group {
                    if let publisher = hero.biography.publisher {
                        infoItem(label: "Publisher", value: publisher)
                    }
                    
                    infoItem(label: "Gender", value: hero.appearance.gender)
                    
                    if let race = hero.appearance.race, !race.isEmpty {
                        infoItem(label: "Race", value: race)
                    }
                }
                .padding(.top, 5)
            }
            .padding()
            .background(cardColor)
        }
        .background(cardColor)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func statBar(label: String, value: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(value)")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    Rectangle()
                        .fill(accentColor)
                        .frame(width: (CGFloat(value) / 100) * geometry.size.width, height: 8)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
    }
    
    private func infoItem(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(configuration.isPressed ? 0.8 : 1))
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct HeroRandomizerView_Previews: PreviewProvider {
    static var previews: some View {
        HeroRandomizerView()
    }
}
