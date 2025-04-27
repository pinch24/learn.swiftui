//
//  SearchFilter.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

struct SearchFilter: View {
	@State private var selectedOption: OptionType = .mailFilter
	@State private var isAnimating: Bool = false
	let filterType: FilterType = .mail
	
	// MARK: - Filter Types
	private var options: [OptionType] {
		switch filterType {
			case .mail:
				return [
					.mailFilter,
					.mailPeriod,
					.mailCustom
				]
			case .project:
				return [
					.projectSort,
					.projectAccess,
					.projectStatus,
					.projectAssignee,
					.projectTag,
					.projectMilestone
				]
			case .calendar:
				return [
					.calendarPeriod,
					.calendarCategory
				]
			case .messenger:
				return []
		}
	}
	
	public enum FilterType {
		case mail
		case project
		case calendar
		case messenger
	}
	
	public enum OptionType {
		case mailFilter
		case mailPeriod
		case mailCustom
		case projectSort
		case projectAccess
		case projectStatus
		case projectAssignee
		case projectTag
		case projectMilestone
		case calendarPeriod
		case calendarCategory
		
		var name: String {
			switch self {
				case .mailFilter:
					return "필터"
				case .mailPeriod:
					return "기간"
				case .mailCustom:
					return "커스텀"
				case .projectSort:
					return "정렬"
				case .projectAccess:
					return "유형"
				case .projectStatus:
					return "업무 상태"
				case .projectAssignee:
					return "담당자"
				case .projectTag:
					return "태그"
				case .projectMilestone:
					return "단계"
				case .calendarPeriod:
					return "기간"
				case .calendarCategory:
					return "캘린더 분류"
			}
		}
		
		var items: [String] {
			switch self {
				case .mailFilter:
					return ["전체", "안읽음", "즐겨찾기", "첨부"]
				case .mailPeriod:
					return ["전체", "오늘", "일주일", "1개월", "6개월", "1년간"]
				case .mailCustom:
					return []
				case .projectSort:
					return ["최근순", "업데이트순", "완료일순", "상태순"]
				case .projectAccess:
					return ["전체", "멤버", "비멤버", "공개"]
				case .projectStatus:
					return ["대기", "등록자미지정", "할 일",
							"Reopen", "Indev", "Resolved", "Closed", "이슈아님(스펙맞음)", "..."]
				case .projectAssignee:
					return []
				case .projectTag:
					return ["Critical", "태그명최대몇글자"]
				case .projectMilestone:
					return ["24년", "일이삼사오육칠팔구십일이삼사육칠파구시", "유료화 리얼",
							"단계최대20자", "24년 7월 개편2차", "24년 7월 개편", "24년 7월 개편4차", "..."]
				case .calendarPeriod:
					return []
				case .calendarCategory:
					return ["Critical", "태그명최대몇글자"]
			}
		}
	}
	
	var body: some View {
		NavigationView {
			VStack {
				segmentView
				
				ScrollViewReader { proxy in
					ScrollView {
						contentView
						Spacer()
					}
					.scrollIndicators(.hidden)
					// Set Scroll by Segment Menu
					.onChange(of: selectedOption) { old, new in
						withAnimation {
							proxy.scrollTo(new, anchor: .top)
							isAnimating = true
							deferAnimationReset()
						}
						
					}
					// Set Segment Menu by Scrolling
					.coordinateSpace(name: "scroll")
					.onPreferenceChange(ViewOffsetPreferenceKey.self) { offsets in
						Task { @MainActor in
							guard isAnimating == false else { return }
							let sorted = offsets
								.sorted { $0.value < $1.value }
								.filter { $0.value > -88 }
							if let first = sorted.first?.key {
								withAnimation {
									selectedOption = first
								}
							}
						}
					}
				}
			}
		}
	}
	
	// Set Segment Menu by Scrolling
	private struct ViewOffsetPreferenceKey: PreferenceKey {
		static let defaultValue: [OptionType: CGFloat] = [:]
		static func reduce(value: inout [OptionType: CGFloat], nextValue: () -> [OptionType: CGFloat]) {
			value.merge(nextValue()) { $1 }
		}
	}
	
	private func deferAnimationReset() {
		Task {
			try? await Task.sleep(for: .milliseconds(400))
			await MainActor.run {
				isAnimating = false
			}
		}
	}
}

// MARK: - 세그먼트 메뉴
extension SearchFilter {
	var segmentView: some View {
		ScrollViewReader { proxy in
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					ForEach(options, id: \.self) { option in
						VStack(spacing: 8) {
							Text(option.name)
								.foregroundStyle(
									selectedOption == option ? Color.primary : Color.secondary
								)
								.onTapGesture {
									withAnimation(.easeInOut(duration: 0.4)) {
										selectedOption = option
										proxy.scrollTo(option)
									}
								}
								// Set Segment Menu by Scrolling
								.background(
									GeometryReader { geo in
										return Color.clear
											.preference(
												key: ViewOffsetPreferenceKey.self,
												value: [option: geo.frame(in: .named("scroll")).minY]
											)
									}
								)
						}
						.padding(.horizontal, 16)
						.id(option)
					}
				}
			}
			Divider()
		}
		.padding(.horizontal)
	}
	
	var contentView: some View {
		VStack(alignment: .leading) {
			ForEach(options, id: \.self) { option in
				VStack(alignment: .leading) {
					Text(option.name)
						.padding(.bottom, 22)
						.background(
							GeometryReader { geo in
								Color.clear
									.preference(
										key: ViewOffsetPreferenceKey.self,
										value: [option: geo.frame(in: .named("scroll")).minY]
									)
							}
						)
					switch option {
						case .mailFilter,
								.mailPeriod,
								.projectSort,
								.projectAccess,
								.projectStatus,
								.projectMilestone:
							GroupedToggleButton(options: option.items)
						case .mailCustom:
							MailDateRangeView()
						case .projectAssignee:
							TextField("", text: .constant(""))
								.frame(height: 22)
								.background(Color.secondary)
								.cornerRadius(16)
						case .projectTag:
							GroupedCheckbox(groupName: "그룹명1", options: option.items, isChip: true)
							GroupedCheckbox(groupName: "그룹명2", options: option.items, isChip: true)
						case .calendarPeriod:
							CalendarDateRangeView()
						case .calendarCategory:
							GroupedCheckbox(groupName: "그룹명1", options: option.items, isChip: false)
							GroupedCheckbox(groupName: "그룹명2", options: option.items, isChip: false)
					}
				}
				.padding(.bottom, 16)
				.id(option)
			}
		}
		.padding()
	}
}

#Preview {
	SearchFilter()
}
