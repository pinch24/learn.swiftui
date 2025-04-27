//
//  SearchFilterSubviews.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

public struct GroupedToggleButton: View {
	let options: [String]
	@State private var selectedOption: String?

	public var body: some View {
		FlowLayout {
			ForEach(options, id: \.self) { option in
				Button(action: {
					selectedOption = option
				}) {
					Text(option)
						.foregroundColor(selectedOption == option ? Color.primary : Color.gray)
						.padding(.horizontal, 10)
						.padding(.vertical, 8)
						.background(
							RoundedRectangle(cornerRadius: 20)
							.stroke(
								selectedOption == option ? Color.primary : Color.secondary,
								lineWidth: 1
							)
						)
						.background(selectedOption == option ? Color.secondary : Color.secondary.opacity(0.4))
						.cornerRadius(20)
				}
			}
		}
	}
}

// MARK: - 필터 옵션: 체크박스
public struct GroupedCheckbox: View {
	let groupName: String
	let options: [String]
	let isChip: Bool
	
	public var body: some View {
		VStack(alignment: .leading) {
			Text(groupName)
				.foregroundColor(Color.secondary)
			ForEach(options, id: \.self) { check in
				CheckboxButton(title: check, backgroundColor: isChip ? Color.random : nil) {
					// action()
				}
			}
		}
	}
}

public struct CheckboxButton: View {
	let title: String
	let backgroundColor: Color?
	@State var isSelected: Bool = false
	let action: () -> Void
	
	public var body: some View {
		Button {
			isSelected.toggle()
			action()
		} label: {
			if isSelected {
				Image(systemName: "checkmark.circle.fill")
					.foregroundStyle(Color.accentColor)
			} else {
				Image(systemName: "circle")
					.foregroundStyle(Color.gray)
			}
			if let backgroundColor {
				Text(title)
					.foregroundColor(Color.white)
					.padding(.horizontal, 8)
					.padding(.vertical, 4)
					.background(backgroundColor)
					.cornerRadius(20)
			} else {
				Text(title)
					.foregroundColor(Color.primary)
					.padding(.vertical, 8)
			}
		}
	}
}

// MARK: - 필터 옵션: 날짜 피커
public struct MailDateRangeView: View {
	@State private var startDate = Date()
	@State private var endDate = Calendar.current.date(
		byAdding: .day,
		value: 30,
		to: Date()
	) ?? Date()
	
	public var body: some View {
		VStack(alignment: .leading) {
			HStack(spacing: 17) {
				DateButton(date: $startDate)
				
				Text("~")
					.foregroundColor(Color.primary)

				DateButton(date: $endDate)
			}
		}
	}

	private struct DateButton: View {
		let title: String = "날짜 선택"
		@Binding var date: Date
		@State private var isPresented: Bool = false
		
		var body: some View {
			Button {
				isPresented = true
			} label: {
				HStack(spacing: 6) {
					Image(systemName: "calendar")
						.foregroundColor(.gray)
					Text(date.dateFormatted(format: "yyyy. MM. dd."))
						.foregroundColor(Color.primary)
				}
				.padding(12)
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(Color.secondary)
				)
			}
			.popover(isPresented: $isPresented) {
				if #available(iOS 16.4, *) {
					DatePicker(title, selection: $date, displayedComponents: .date)
						.datePickerStyle(.graphical)
						.padding()
						.frame(width: 280)
						.presentationCompactAdaptation(.popover)
				} else {
					DatePicker(title, selection: $date, displayedComponents: .date)
						.datePickerStyle(.wheel)
						.padding()
						.presentationDetents([.fraction(0.25)])
				}
			}
		}
	}
}

public struct CalendarDateRangeView: View {
	@State private var startDate = Date()
	@State private var endDate = Calendar.current.date(
		byAdding: .minute,
		value: 30,
		to: Date()
	)  ?? Date()
	@State private var isAllDay = false
	
	public var body: some View {
		HStack(spacing: 12) {
			DateLabel(date: $startDate, isAllDay: isAllDay)
			
			Image(systemName: "chevron.right")
				.foregroundColor(.gray)
			
			DateLabel(date: $endDate, isAllDay: isAllDay)
			
			Spacer()
			
			Button(action: {
				isAllDay.toggle()
			}) {
				Text("종일")
					.foregroundColor(isAllDay ? Color.accentColor : Color.gray)
					.padding(.horizontal, 10)
					.padding(.vertical, 8)
					.background(
						RoundedRectangle(cornerRadius: 20)
							.stroke(isAllDay ? Color.accentColor : Color.gray, lineWidth: 1)
					)
					.background(isAllDay ? Color.accentColor : Color.white)
					.cornerRadius(20)
			}
		}
		.padding()
	}
	
	private struct DateLabel: View {
		let title: String = "날짜 선택"
		@Binding var date: Date
		@State private var isPresented: Bool = false
		let isAllDay: Bool
		
		var body: some View {
			Button {
				isPresented = true
			} label: {
				VStack(alignment: .leading, spacing: 4) {
					Text(date.dateFormatted(format: "M월 d일 (E)"))
						.foregroundColor(Color.primary)
					if isAllDay == false {
						Text(date.dateFormatted(format: "a h:mm"))
							.foregroundColor(Color.primary)
					}
				}
			}
			.popover(isPresented: $isPresented) {
				if #available(iOS 16.4, *) {
					DatePicker(title,
							   selection: $date,
							   displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
						.datePickerStyle(.graphical)
						.padding()
						.frame(width: 280)
						.presentationCompactAdaptation(.popover)
				} else {
						DatePicker(title,
								   selection: $date,
								   displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
						.datePickerStyle(.wheel)
						.padding()
						.presentationDetents([.fraction(0.25)])
				}
			}
		}
	}
}

#Preview {
	SearchFilter()
}
