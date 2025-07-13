//
//  MoreListView.swift
//  TCAWorks
//
//  Created by MK on 7/13/25.
//

import SwiftUI

struct MoreListView: View {
	@State private var fruits = [
		"🍎 사과",
		"🍌 바나나",
		"🍊 오렌지",
		"🍇 포도",
		"🍓 딸기"
	]
	
	@State private var animals = [
		"🐶 강아지",
		"🐱 고양이",
		"🐭 쥐",
		"🐹 햄스터",
		"🐰 토끼"
	]
	
	// 편집 모드 상태 추적
	@State private var editMode: EditMode = .inactive
	
	var body: some View {
		NavigationView {
			List {
				// 과일 섹션
				Section(header: Text("과일")) {
					ForEach(fruits, id: \.self) { fruit in
						Text(fruit)
					}
					.onDelete { indexSet in
						print("🗑️ Delete called - 과일 섹션")
						print("  삭제할 인덱스: \(indexSet)")
						print("  삭제할 항목: \(indexSet.map { fruits[$0] })")
						fruits.remove(atOffsets: indexSet)
					}
					.onMove { source, destination in
						print("🔄 Move called - 과일 섹션")
						print("  source: \(source)")
						print("  destination: \(destination)")
						print("  이동할 항목: \(source.map { fruits[$0] })")
						fruits.move(fromOffsets: source, toOffset: destination)
					}
				}
				
				// 동물 섹션
				Section(header: Text("동물")) {
					ForEach(animals, id: \.self) { animal in
						Text(animal)
					}
					.onDelete { indexSet in
						print("🗑️ Delete called - 동물 섹션")
						print("  삭제할 인덱스: \(indexSet)")
						print("  삭제할 항목: \(indexSet.map { animals[$0] })")
						animals.remove(atOffsets: indexSet)
					}
					.onMove { source, destination in
						print("🔄 Move called - 동물 섹션")
						print("  source: \(source)")
						print("  destination: \(destination)")
						print("  이동할 항목: \(source.map { animals[$0] })")
						animals.move(fromOffsets: source, toOffset: destination)
					}
				}
			}
			.listStyle(PlainListStyle())
			.navigationTitle("과일/동물")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
				ToolbarItem(placement: .navigationBarLeading) {
					Text(editMode == .active ? "편집 중" : "일반 모드")
						.font(.caption)
						.foregroundColor(.gray)
				}
			}
			.environment(\.editMode, $editMode)
			.onChange(of: editMode) { oldValue, newValue in
				print("📝 Edit Mode Changed: \(newValue == .active ? "Active" : "Inactive")")
			}
		}
	}
}

#Preview {
	MoreListView()
}

