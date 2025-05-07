// HeroDraft.swift
import Foundation

/// Contenedor sencillo para reunir la entrada del usuario antes de iniciar la historia
struct HeroDraft: Equatable {
    var name        = ""
    var role        = ""
    var personality = ""
    var world       = "Random"
    var genre       = "Random"
    
    var incomplete: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        role.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        personality.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
