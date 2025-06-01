//
//  CalendarMainView.swift
//  TCAWorks
//
//  Created by MK on 5/15/25.
//

import ComposableArchitecture
import SwiftUI

public struct CalendarMainView: View {
	struct Constants {
		static let lineCount = 1
	}
	
	// 화면에 표시할(로딩된) 캘린더 리스트
	@State var visibleList: [Int] = [
		Calendar.current.date(byAdding: .month, value: -5, to: Date())!.toInt(format: "yyyyMM"),
		Calendar.current.date(byAdding: .month, value: -4, to: Date())!.toInt(format: "yyyyMM"),
		Calendar.current.date(byAdding: .month, value: -3, to: Date())!.toInt(format: "yyyyMM"),
		Calendar.current.date(byAdding: .month, value: -2, to: Date())!.toInt(format: "yyyyMM"),
		Calendar.current.date(byAdding: .month, value: -1, to: Date())!.toInt(format: "yyyyMM"),     // 지난 달
		Date().toInt(format: "yyyyMM"),                                                              // 이번 달
		Calendar.current.date(byAdding: .month, value: +1, to: Date())!.toInt(format: "yyyyMM"),     // 다음 달
		Calendar.current.date(byAdding: .month, value: +2, to: Date())!.toInt(format: "yyyyMM"),
		Calendar.current.date(byAdding: .month, value: +3, to: Date())!.toInt(format: "yyyyMM"),
		Calendar.current.date(byAdding: .month, value: +4, to: Date())!.toInt(format: "yyyyMM"),
		Calendar.current.date(byAdding: .month, value: +5, to: Date())!.toInt(format: "yyyyMM"),
	]
	
	// UI 업데이트 블로킹 - 스크롤이 튀는 걸 방지하기 위한 프로퍼티
	@State private var isScrollLocked = true
	
	// 캘린더 셀 높이 프로퍼티
	@State private var heightDisp = 5.0
	
	// 컨텍스트 메뉴
	@State private var isShowContextMenu = false
	@State var frame = CGRect.zero
	
	private let store: StoreOf<CalendarMainReducer>
	
	init(store: StoreOf<CalendarMainReducer>) {
		self.store = store
		
#if DEBUG
		// TODO: 임시 테스트 데이터
		self.store.send(.viewAction(.setEvents(CalendarMainPreview.sample())))
#endif
	}

	public var body: some View {
		ZStack {
			monthPagingView
				.safeAreaInset(edge: .top) {
					monthHeaderView
				}
			
			// 컨텍스트 메뉴
			ContextMenu2(show: $isShowContextMenu, frame: $frame) {
				Button("월간", action: {
					isShowContextMenu.toggle()
				})
				Button("주간", action: {
					isShowContextMenu.toggle()
				})
				Button("일간", action: {
					isShowContextMenu.toggle()
				})
			}
		}
	}
	
	// Calendar Header
	private var monthHeaderView: some View {
		VStack {
			NavigationBar(
				title: store.viewState.selectedDateValue.toYYYYMMString(delimiter: "."),
				rightItems: [
					NavigationBarItem(iconView: AnyView(
						HStack(spacing: .zero) {
							// TODO: 문자 리터럴
							Text("월간")
								.font(.caption)
							Image(systemName: "chevron.down")
						}
						.frame(width: 53, height: 30)
						.foregroundColor(.primary)
						.background(
							RoundedRectangle(cornerRadius: 20)
								.stroke(.secondary)
						)
						.overlay(
							// TODO: 위치 조정 필요
							ContextMenu2.setFrame($frame)
						)
					)) {
						isShowContextMenu.toggle()
					},
					NavigationBarItem(iconView: AnyView(Image(systemName: "magnifyingglass"))) {
						// ...
					},
					NavigationBarItem(iconView: AnyView(Image(systemName: "ellipsis"))) {
						// ...
					},
				],
				onMenu: {
					//viewStore.send(.toggleDrawerMenu, animation: .easeInOut)
				}
			)
			.background(BlurEffect())
			
			HStack {
				ForEach(Date.getWeekday(), id: \.self) { day in
					Text(day)
						.font(.headline)
						.frame(maxWidth: .infinity)
				}
			}
		}
		.background(Color.background)
	}
	
	// Calendar Grid
	private var monthPagingView: some View {
		ScrollViewReader { proxy in
			ScrollView {
				LazyVStack {
					ForEach(visibleList, id: \.self) { month in
						calendarGridView(month)
							// NOTE: 앱바 타이틀에 표시되는 년월을 업데이트하기 위한 GeometryReader
							// 이 GeometryReader 때문에 스크롤 시 경직 현상이 발생
							.background(
								GeometryReader { geo in
									Color.clear
										.onChange(of: geo.frame(in: .named("scroll")).minY) { old, new in
											guard isScrollLocked == false else { return }
											let threshold: CGFloat = 400
											if new < threshold && new > -threshold {
												print(".onChange - \(month)")
												if store.viewState.selectedDateValue != month {
													store.send(.viewAction(.setSelectedDate(month)))
												}
											}
										}
								})
					}
				}
			}
			.coordinateSpace(name: "scroll")
			.scrollIndicators(.hidden)
			.task {
				// 화면이 시작될 때 현재 월로 이동
				let dateValue = store.viewState.selectedDateValue
				print(".task - .scrollTo: \(dateValue)")
				proxy.scrollTo(dateValue, anchor: .top)
				isScrollLocked = true
				try? await Task.sleep(for: .milliseconds(400))
				isScrollLocked = false
			}
			// 핀치 제스쳐 처리 - 셀 높이 변경
			.simultaneousGesture(
				MagnificationGesture()
					.onChanged { offset in
						let base: CGFloat = 5.0
						let limit: CGFloat = 12.0
						let value = offset - 1.0
						heightDisp = min(max(base, heightDisp + value), limit)
						//print(".simultaneousGesture - \(Int(heightDisp))")
					}
			)
			//.animation(.smooth, value: heightDisp)
		}
	}
	
	@ViewBuilder
	private func calendarGridView(_ dateValue: Int) -> some View {
		Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
			let weeks = generateWeeks(date: Date.from(dateValue, format: "yyyyMM"))
			ForEach(weeks, id: \.self) { days in
				GridRow {
					// 날짜 표시
					ForEach(days, id: \.self) { day in
						dateView(day)
					}
				}
				// 이벤트 표시
				Group {
					ForEach(0..<Int(heightDisp), id: \.self) { row in
						GridRow {
							ForEach(days, id: \.self) { day in
								eventView(day: day, row: row)
							}
						}
						//.frame(height: 16)
						//.border(Color.gray.opacity(0.4), width: 0.4)	// TEST:
					}
				}
			}
		}
	}
	
	@ViewBuilder
	private func eventView(day: CalendarDay, row: Int) -> some View {
		// 날짜에 해당하는 이벤트 리스트 중 현재 행(row) 데이터만 추출
		let events = store.viewState.events
		let rowEvents = getVisibleEventList(events: events, day: day, height: heightDisp * 16)
		let matchedEvent = rowEvents.first(where: { $0.rect.1 == row })
		if let event = matchedEvent {
			// 이벤트 시작일과 같은 주
			let isSameWeek = event.date.startOfWeek == day.date.startOfWeek
			if isSameWeek {
				// 이벤트 시작일과 같은 날
				let isFirstDay = day.date.toInt(format: "yyyyMMdd") == event.date.toInt(format: "yyyyMMdd")
				if isFirstDay {
					// Span 처리할 Column 계산
					let index = event.rect.0
					let span = event.rect.2
					let cols = max(min(span, (7 - index)), 1) // cols: 1 <= span <= 7
					eventLabel(day, event)
						.gridCellColumns(cols)
						//.border(Color.brown.opacity(0.4), width: 0.2)   // TEST:
				}
			}
			// 연속 이벤트의 남은 레이블 표시 - case. 이벤트 시작일과 다른 주의 표시될 레이블
			else {
				eventLabel(day, event)
			}
		}
		
//		let color = Color.random
//		let event = CalendarEvent(
//			date: day.date,
//			endDate: nil,
//			title: "\(day.day), \(row)",
//			textColor: color,
//			labelColor: color.opacity(0.4),
//			notes: "",
//			location: "",
//			participants: [],
//			scheduleType: .allDay,
//			rect: (1, row, 1, 1)
//		)
//		eventLabel(day, event)
	}
	
	private func dateView(_ day: CalendarDay) -> some View {
		Text("\(day.day)")
			.font(.subheadline)
			.lineLimit(Constants.lineCount)
			.foregroundStyle(
				day.isInMonth == false ? .quaternary :		// 이전/이후 월
					(day.isToday ? .primary :       		// 오늘
						(day.isWeekend ? .secondary :   	// 주말
							.primary))						// 평일
			)
			.background(
				Circle()
					.fill(day.isToday ? .blue.opacity(0.2) : .clear)
					.scaleEffect(2.8)
			)
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.vertical, 4)
			.onTapGesture {
				store.send(.viewAction(.setSelectedDate(day.date.toInt(format: "yyyyMM"))))
				print("SELECTED DATE - \(day.date)")
			}
	}
	
	// 이벤트 레이블
	private func eventLabel(_ day: CalendarDay, _ event: CalendarEvent) -> some View {
		let isFirstDay: Bool = day.date.toInt(format: "yyyyMMdd") == event.date.toInt(format: "yyyyMMdd")
		let isLastDay: Bool = event.endDate == nil || day.date.toInt(format: "yyyyMMdd") == event.endDate?.toInt(format: "yyyyMMdd")
		let isMiddleDay = isFirstDay == false && isLastDay == false
		return Text(event.title)
			.font(.caption2)
			.foregroundStyle(isFirstDay ? event.textColor : .clear)
			.lineLimit(Constants.lineCount)
			.padding(.vertical, 3)
			.frame(maxWidth: .infinity, alignment: .leading)
			.modifier(EventBulletModifier(event: event, isShow: isFirstDay))
			.modifier(EventLabelModifier(event: event, isShow: isFirstDay != isLastDay || isMiddleDay))
			.modifier(EventBorderModifier(isLeading: isFirstDay, isTrailing: isLastDay))
			//.offset(x: event.labelType == .info ? 20 : 0)   // TODO: UI 조정
	}
	
	private func generateDays(date: Date) -> [CalendarDay?] {
		let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
		let range = Calendar.current.range(of: .day, in: .month, for: startOfMonth)!
		let firstWeekday = Calendar.current.component(.weekday, from: startOfMonth) - Calendar.current.firstWeekday
		
		// 이번 달 날짜
		let days = range.map { day -> CalendarDay in
			let dayDate = Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth)!
			return CalendarDay(date: dayDate, day: day, isInMonth: true)
		}
		
		// 이전 달 날짜
		let leadingEmptyDays = (firstWeekday + 7) % 7
		let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: startOfMonth)!
		let previousMonthRange = Calendar.current.range(of: .day, in: .month, for: previousMonth)!
		var leadingDays: [CalendarDay] = []
		if leadingEmptyDays > 0 {
			let trailingDaysStart = previousMonthRange.count - leadingEmptyDays + 1
			if trailingDaysStart <= previousMonthRange.count {
				leadingDays = (trailingDaysStart...previousMonthRange.count).map { day in
					let dayDate = Calendar.current.date(byAdding: .day, value: day - 1, to: previousMonth)!
					return CalendarDay(date: dayDate, day: day, isInMonth: false)
				}
			}
		}
		let paddedDays: [CalendarDay?] = leadingDays.map { Optional($0) } + days.map { Optional($0) }
		
		// 다음 달 날짜
		let totalCount = paddedDays.count
		let rows = Int(ceil(Double(totalCount) / 7.0))
		let needed = rows * 7
		let remaining = needed - totalCount

		if remaining > 0 {
			let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!
			let nextMonthDays = (1...remaining).map { offset -> CalendarDay? in
				let dayDate = Calendar.current.date(byAdding: .day, value: offset - 1, to: nextMonth)!
				return CalendarDay(date: dayDate, day: offset, isInMonth: false)
			}
			return paddedDays + nextMonthDays
		} else {
			return paddedDays
		}
	}
}

// MARK: - View Modifier for Event Label
extension CalendarMainView {
	// Bullet - 이벤트 레이블의 불릿 처리
	struct EventBulletModifier: ViewModifier {
		let event: CalendarEvent
		let isShow: Bool
		func body(content: Content) -> some View {
			switch event.scheduleType {
				case .allDay:
					content
						.padding(.leading, 4)
				case .busy, .free, .yet, .closed, .canceled:
					HStack(spacing: 2) {
						Capsule()
							.frame(width: 2, height: 10)
							.foregroundStyle(isShow ? event.textColor : .clear)
							.padding(.leading, 2)
						content
					}
				case .secret:
					HStack(spacing: 2) {
						Image(systemName: "bell")
							.resizable()
							.renderingMode(.template)
							.foregroundStyle(isShow ? event.textColor : .clear)
							.frame(width: 10, height: 10)
							.padding(.leading, 2)
						content
					}
				case .task:
					HStack(spacing: 2) {
						Image(systemName: "calendar")
							.resizable()
							.renderingMode(.template)
							.foregroundStyle(isShow ? event.textColor : .clear)
							.frame(width: 10, height: 10)
							.padding(.leading, 2)
						content
					}
					
				case .count:
					content
					
				case .empty:
					content
			}
		}
	}
	
	// Label - 이벤트 레이블의 배경 처리
	struct EventLabelModifier: ViewModifier {
		let event: CalendarEvent
		let isShow: Bool
		func body(content: Content) -> some View {
			switch event.scheduleType {
				case .allDay, .busy, .yet, .secret:
					content
						.background(event.labelColor)
				case .free:
					content
						.background(
							HatchingEffect(color: event.textColor.opacity(0.2))
								.background(event.labelColor)
						)
				case .closed:
					content
						.background(event.labelColor)
						.overlay(
							RoundedRectangle(cornerRadius: 4)
								.strokeBorder(event.textColor, style: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
						)
				case .canceled:
					content
						.strikethrough(true, color: event.textColor)
						.background(event.labelColor)
						.overlay(
							RoundedRectangle(cornerRadius: 4)
								.stroke(event.textColor, style: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
						)
						.opacity(0.8)
				case .task:
					content
						.background(isShow ? event.labelColor : .clear)
					
				case .count:
					HStack {
						content
							.scaleEffect(0.8)
							.background(event.labelColor)
							.frame(width: 22, height: 13)
					}
					
				case .empty:
					content
			}
		}
	}
	
	// Border - 이벤트 레이블의 시작일(왼쪽)/종료일(오른쪽) 라운드 처리
	struct EventBorderModifier: ViewModifier {
		let isLeading: Bool
		let isTrailing: Bool

		func body(content: Content) -> some View {
			let shape: AnyShape = {
				switch (isLeading, isTrailing) {
					case (true, true): return AnyShape(RoundedShape())
					case (true, false): return AnyShape(LeftRoundedShape())
					case (false, true): return AnyShape(RightRoundedShape())
					case (false, false): return AnyShape(Rectangle())
				}
			}()
			return content
				.clipShape(shape)
				.padding(.leading, isLeading ? 1 : 0)
				.padding(.trailing, isTrailing ? 1 : 0)
		}
	}
	
	struct RoundedShape: Shape {
		func path(in rect: CGRect) -> Path {
			let radius: CGFloat = 4
			return RoundedRectangle(cornerRadius: radius).path(in: rect)
		}
	}

	struct RightRoundedShape: Shape {
		func path(in rect: CGRect) -> Path {
			let radius: CGFloat = 4
			var path = Path()
			path.move(to: CGPoint(x: rect.minX, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
			path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
						radius: radius,
						startAngle: .degrees(-90),
						endAngle: .degrees(0),
						clockwise: false)
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
			path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
						radius: radius,
						startAngle: .degrees(0),
						endAngle: .degrees(90),
						clockwise: false)
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
			path.closeSubpath()
			return path
		}
	}

	struct LeftRoundedShape: Shape {
		func path(in rect: CGRect) -> Path {
			let radius: CGFloat = 4
			var path = Path()
			path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
			path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
						radius: radius,
						startAngle: .degrees(-90),
						endAngle: .degrees(-180),
						clockwise: true)
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
			path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
						radius: radius,
						startAngle: .degrees(-180),
						endAngle: .degrees(-270),
						clockwise: true)
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
			path.closeSubpath()
			return path
		}
	}
}

// TODO: CommonUI - BlurEffect 처럼 공통 모듈로 구성
struct HatchingEffect: View {
	let color: Color
	let spacing: CGFloat = 4
	
	var body: some View {
		GeometryReader { geometry in
			Path { path in
				let size = geometry.size
				var x: CGFloat = 0
				while x < size.width + size.height {
					path.move(to: CGPoint(x: x, y: 0))
					path.addLine(to: CGPoint(x: x - size.height, y: size.height))
					x += spacing
				}
			}
			.stroke(color, lineWidth: 1)
		}
		.clipped()
	}
}

#if DEBUG
#Preview {
	CalendarMainPreview()
}

struct CalendarMainPreview: View {
	var body: some View {
		CalendarMainView(
			store: Store(
				initialState: CalendarMainReducer.State(events: .init(CalendarMainPreview.sample()), selectedDateValue: Date().toInt(format: "yyyyMM")),
				reducer: {
					CalendarMainReducer()
				}
			)
		)
	}
	
	static func sample() -> [CalendarEvent] {
		[
			CalendarEvent(
				date: Date.from("2025.05.05"),
				endDate: nil,
				title: "부처님오신날",
				textColor: .pink,
				labelColor: .pink.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (1, 0, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.05.05"),
				endDate: nil,
				title: "어린이날",
				textColor: .pink,
				labelColor: .pink.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (1, 1, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.05.06"),
				endDate: nil,
				title: "어린이날(대체휴일)",
				textColor: .pink,
				labelColor: .pink.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (2, 0, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.02"),
				endDate: nil,
				title: "대통령 선거일",
				textColor: .pink,
				labelColor: .pink.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (1, 0, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.06"),
				endDate: nil,
				title: "현충일",
				textColor: .pink,
				labelColor: .pink.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (1, 1, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.25"),
				endDate: nil,
				title: "문화의 날",
				textColor: .pink,
				labelColor: .pink.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (2, 0, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.05 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.05 11:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "D-TF 주간회의",
				textColor: .green,
				labelColor: .green.opacity(0.1),
				notes: "Daily sync meeting with team",
				location: "페이코룸",
				participants: ["앨리스", "밥", "찰리"],
				scheduleType: .busy,
				rect: (3, 0, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.09 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.09 15:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "[북토크]트렌드 20XX",
				textColor: .blue,
				labelColor: .blue.opacity(0.1),
				notes: "김난도 교수 초청",
				location: "컨퍼런스룸",
				participants: [],
				scheduleType: .free,
				rect: (4, 0, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.09 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.09 17:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "방향성 보고",
				textColor: .yellow,
				labelColor: .yellow.opacity(0.1),
				notes: "",
				location: "8-3",
				participants: ["루키"],
				scheduleType: .closed,
				rect: (4, 1, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.12 18:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.12 19:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "야근",
				textColor: .cyan,
				labelColor: .cyan.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .secret,
				rect: (1, 0, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.13 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.13 17:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "프로덕트 디자인",
				textColor: .brown,
				labelColor: .brown.opacity(0.1),
				notes: "Sprint planning for Q3",
				location: "8-0",
				participants: ["제품팀"],
				scheduleType: .canceled,
				rect: (2, 0, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.16 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.16 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "플레이뮤지엄 리뉴얼",
				textColor: .purple,
				labelColor: .purple.opacity(0.1),
				notes: "스프린트",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (3, 0, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.16 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.16 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "직무교육",
				textColor: .brown,
				labelColor: .brown.opacity(0.1),
				notes: "회의",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (3, 1, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.17"),
				endDate: Date.from("2025.06.18"),
				title: "[휴가] 조예리",
				textColor: .gray,
				labelColor: .gray.opacity(0.1),
				notes: "개인사유",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (4, 0, 2, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.24 08:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 09:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 1",
				textColor: .mint,
				labelColor: .mint.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (1, 0, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.24 09:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 2",
				textColor: .orange,
				labelColor: .orange.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (1, 2, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.24 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 3",
				textColor: .teal,
				labelColor: .teal.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (1, 3, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.24 12:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 13:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 4",
				textColor: .gray,
				labelColor: .gray.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (1, 4, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.24 13:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 5",
				textColor: .brown,
				labelColor: .brown.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (1, 5, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 6",
				textColor: .green,
				labelColor: .green.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (1, 6, 1, 1)
			),
			CalendarEvent(
				date: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 7",
				textColor: .blue,
				labelColor: .blue.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (1, 7, 1, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.19"),
				endDate: Date.from("2025.06.23"),
				title: "연속 이벤트 - 1. Hello, world.",
				textColor: .indigo,
				labelColor: .indigo.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (4, 0, 4, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.20"),
				endDate: Date.from("2025.07.04"),
				title: "연속 이벤트 - 2. It's no use crying over spilt milk.",
				textColor: .purple,
				labelColor: .purple.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (5, 1, 14, 1)
			),
			
			CalendarEvent(
				date: Date.from("2025.06.26"),
				endDate: Date.from("2025.06.30"),
				title: "연속 이벤트 - 3. Life goes on.",
				textColor: .orange,
				labelColor: .orange.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (4, 2, 5, 2)
			),
		]
	}
}
#endif

