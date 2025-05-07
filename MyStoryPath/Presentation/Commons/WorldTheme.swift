// WorldTheme.swift
import SwiftUI

/// Paleta de degradado e icono asociado a cada mundo narrativo
struct WorldTheme {
    let gradient: [Color]
    let icon: String
    
    /// Lista centralizada de mundos disponibles (el primero es “Random”)
    static let all: [String] = [
        "Random", "Medieval Fantasy", "Outer Space", "Cyber Reality", "Middle Ages",
        "Post‑apocalyptic", "Magical Jungle", "Underwater World", "Magical Realism", "Modern City",
        "Steampunk", "Dystopian Future", "Enchanted Forest", "Mystic Desert", "Lost Island",
        "Alternate Dimension", "Ancient Temple", "Unknown Planet", "Floating City", "Tech Ruins"
    ]

    static func theme(for world: String) -> WorldTheme {
        switch world {
        case "Outer Space":        return WorldTheme(gradient: [.purple, .blue], icon: "sparkles")
        case "Cyber Reality":      return WorldTheme(gradient: [.cyan, .mint], icon: "cpu")
        case "Post‑apocalyptic":   return WorldTheme(gradient: [.gray, .black], icon: "radiowaves.left")
        case "Magical Jungle":     return WorldTheme(gradient: [.green, .teal], icon: "leaf.fill")
        case "Underwater World":   return WorldTheme(gradient: [.blue, .indigo], icon: "drop.fill")
        case "Magical Realism":    return WorldTheme(gradient: [.orange, .pink], icon: "wand.and.stars")
        case "Modern City":        return WorldTheme(gradient: [.gray, .blue], icon: "building.2")
        case "Medieval Fantasy":   return WorldTheme(gradient: [.purple, .indigo], icon: "flame.fill")
        case "Enchanted Forest":   return WorldTheme(gradient: [.green, .brown], icon: "tree.fill")
        case "Mystic Desert":      return WorldTheme(gradient: [.yellow, .orange], icon: "sun.max.fill")
        case "Lost Island":        return WorldTheme(gradient: [.cyan, .blue], icon: "map.fill")
        case "Floating City":      return WorldTheme(gradient: [.mint, .gray], icon: "cloud.fill")
        case "Tech Ruins":         return WorldTheme(gradient: [.gray, .mint], icon: "gearshape.2.fill")
        case "Alternate Dimension":return WorldTheme(gradient: [.indigo, .black], icon: "circle.dashed.inset.filled")
        case "Ancient Temple":     return WorldTheme(gradient: [.orange, .brown], icon: "building.columns")
        case "Unknown Planet":     return WorldTheme(gradient: [.indigo, .purple], icon: "globe")
        case "Middle Ages":        return WorldTheme(gradient: [.brown, .gray], icon: "shield.lefthalf.fill")
        default:                   return WorldTheme(gradient: [.purple, .indigo], icon: "book")
        }
    }
}
