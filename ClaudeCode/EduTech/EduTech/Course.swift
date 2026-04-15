import Foundation

struct Course: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let iconName: String
    let duration: String
    let lectureCount: Int
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
}

// MARK: - Sample Data

extension Category {
    static let samples: [Category] = [
        Category(name: "Swift", iconName: "swift"),
        Category(name: "Java", iconName: "cup.and.saucer.fill"),
        Category(name: "Python", iconName: "laptopcomputer"),
        Category(name: "Web", iconName: "globe"),
        Category(name: "AI", iconName: "brain.head.profile")
    ]
}

extension Course {
    static let samples: [Course] = [
        Course(title: "Front-End", subtitle: "Web Development Course", iconName: "globe", duration: "8 hours", lectureCount: 42),
        Course(title: "Back-End", subtitle: "Web Development Course", iconName: "server.rack", duration: "12 hours", lectureCount: 56),
        Course(title: "JavaScript", subtitle: "Web Development Course", iconName: "curlybraces", duration: "10 hours", lectureCount: 38),
        Course(title: "Swift Development", subtitle: "iOS App Course", iconName: "swift", duration: "14 hours", lectureCount: 48),
        Course(title: "Python Development", subtitle: "Data Science Course", iconName: "laptopcomputer", duration: "20 hours", lectureCount: 64)
    ]
}
