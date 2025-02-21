import Foundation

struct PromptTemplate: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let content: String
}

let presetPrompts: [PromptTemplate] = [
    PromptTemplate(
        title: "Video Script",
        description: "Generate a story with prompts",
        content: """
        Create a short story with 5 scenes, including video generation prompts and captions for each scene:

        Theme: A day in the life of a young artist
        Style: Cinematic, warm colors, shallow depth of field
        Length: 5 scenes, 5-10 seconds each

        Please provide for each scene:
        1. Video Generation Prompt (detailed visual description)
        2. Voiceover text for scene
        3. Music/Sound Mood

        Example Scene Format:
        Scene 1:
        - Prompt: Close-up shot of artist's hands mixing paint on a wooden palette, morning sunlight streaming through window, soft focus background of art studio
        - Caption: "Every morning begins with a blank canvas and endless possibilities"
        - Duration: 30 seconds
        - Audio: Soft piano, gentle morning ambience
        """
    ),
    PromptTemplate(
        title: "App Idea",
        description: "Develop your app concept",
        content: """
        Help me develop this app idea into a structured product plan:

        App concept: Local Event Finder
        - discover nearby events
        - save favorites
        - buy tickets
        - rate events

        Please organize into:
        - Core Features
        - User Benefits
        - Monetization Strategy
        """
    ),
    PromptTemplate(
        title: "SwiftUI Code",
        description: "Generate code for UI",
        content: """
        Generate SwiftUI code with explanations for the following feature:

        Create a custom button with:
        - Gradient background
        - Shadow effect
        - Scale animation on tap
        - Icon with text
        - Rounded corners

        Please include:
        - Full code with syntax highlighting
        - Comments explaining key parts
        """
    ),
]
