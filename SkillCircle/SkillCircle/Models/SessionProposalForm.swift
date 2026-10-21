import Foundation
import CoreLocation

enum SessionGoal: String, CaseIterable, Identifiable, Codable {
    case teaching = "I Am Teaching A Subject"
    case learning = "I Am Learning A Subject"
    
    var id: String { self.rawValue }
}

enum SessionMethod: String, CaseIterable, Identifiable, Codable {
    case physical = "Physical"
    case online = "Online"
    
    var id: String { self.rawValue }
}

enum PhysicalLocationType: String, CaseIterable, Identifiable, Codable {
    case indoor = "Indoor Location"
    case pinOnMap = "Pin On Map"
    
    var id: String { self.rawValue }
}

struct SessionProposalForm: Codable {
    var goal: SessionGoal = .teaching
    var subjectName: String = "STATISTICS"
    var selectedDate: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(7200) // +2 hours
    var method: SessionMethod = .physical
    var physicalLocationType: PhysicalLocationType = .indoor
    
    // Indoor details
    var building: String = "Main Building"
    var floor: String = "3rd Floor"
    var room: String = "Library"
    
    // Map pin details
    var latitude: Double = 6.9010
    var longitude: Double = 79.8606
    
    // Online details
    var meetingLink: String = ""
    
    var estimatedTokens: Int {
        return 1
    }
}