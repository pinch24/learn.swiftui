import SwiftUI

struct HomeView: View {
    @Binding var isDrawerOpen: Bool
    @State private var searchText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search...", text: $searchText)
                }
                .padding(12)
                .glassEffect(in: .rect(cornerRadius: 14))

                // MARK: - Recommended for you
                VStack(alignment: .leading, spacing: 14) {
                    Text("Recommended for you")
                        .font(.title3)
                        .fontWeight(.bold)

                    ScrollView(.horizontal, showsIndicators: false) {
                        GlassEffectContainer(spacing: 16) {
                            HStack(spacing: 16) {
                                ForEach(Category.samples) { category in
                                    CategoryCard(category: category)
                                }
                            }
                        }
                    }
                }

                // MARK: - Last seen courses
                VStack(alignment: .leading, spacing: 14) {
                    Text("Last seen courses")
                        .font(.title3)
                        .fontWeight(.bold)

                    GlassEffectContainer(spacing: 12) {
                        VStack(spacing: 12) {
                            ForEach(Course.samples) { course in
                                CourseRow(course: course)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 30)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isDrawerOpen.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "person.fill")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
            }
        }
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: Category

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: category.iconName)
                .font(.title2)
                .foregroundStyle(.primary)
                .frame(width: 70, height: 70)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 18))

            Text(category.name)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Course Row

struct CourseRow: View {
    let course: Course

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(course.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
        }
        .padding(16)
        .glassEffect(in: .rect(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        HomeView(isDrawerOpen: .constant(false))
    }
}
