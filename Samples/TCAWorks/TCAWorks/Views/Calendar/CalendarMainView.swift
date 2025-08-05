//
//  CalendarMainView.swift
//  TCAWorks
//
//  Created by MK on 5/15/25.
//

import SwiftUI
import ComposableArchitecture

public struct CalendarMainView: View {
	private let store: StoreOf<CalendarMainReducer>
	init(store: StoreOf<CalendarMainReducer>) {
		self.store = store
	}

	@State private var contextMenuPosition = CGPoint.zero
	@State private var contextMenuShow = false

	// 페이징 관련
	public enum ScrollDirection: Sendable { case none, up, down }
	@State private var scrollDirection = ScrollDirection.none
	@State private var dragOffset: CGFloat = 0

	// 줌 관련
	@State private var isZoomedIn: Bool = false
	@State private var zoomScale: CGFloat = 1.0
	@State private var currentPinchScale: CGFloat = 1.0
	@State private var weekScrollOffset: CGPoint = .zero
	@State private var pinchStartLocation: CGPoint = .zero
	@State private var targetWeekIndex: Int = 0
	@State private var zoomedScrollOffset: CGFloat = 0
	@State private var isScrollAtTop: Bool = false
	@State private var isScrollAtBottom: Bool = false
	@State private var forceScrollToTop: Bool = false
	@State private var forceScrollToBottom: Bool = false
	@State private var isPinching: Bool = false

	public var body: some View {
		ZStack {
			VStack {
				headerView
					.zIndex(1)
				pagingView
					.onAppear {
						#if DEBUG
						// 캘린더 사이드 메뉴 데이터
						store.send(.changeAction(.updateMenus("내 캘린더", CalendarSideMenuPreview.getCalendarMenu())))
						// 캘린더 이벤트 데이터
						let events = CalendarMainPreview.getCalendarEvent06()
						+ CalendarMainPreview.getCalendarEvent07()
						+ CalendarMainPreview.getCalendarEvent08()
						+ CalendarMainPreview.getCalendarEvent09()
						+ CalendarMainPreview.getCalendarEvent10()
						store.send(.changeAction(.updateEvents(events)))
						#endif
						// NOTE: 초기 로딩 시 현재 월 데이터 로드
						store.send(.viewAction(.onAppear(Date().yearMonth)))
					}
			}
			contextMenuView
		}
		.overlay(alignment: .leading) {
			if store.isShowSideMenu {
				drawerMenu
			}
		}
	}

	// 캘린더 페이징 뷰
	private var pagingView: some View {
		GeometryReader { geo in
			let prevMonth = store.prevMonth
			let nextMonth = store.nextMonth
			let selectedMonth = store.selectedMonth
			let monthHeight = geo.size.height

			let hasPrevMonth = store.daysList[prevMonth] != nil
			let hasNextMonth = store.daysList[nextMonth] != nil

			ZStack {
				// 이전 월
				if hasPrevMonth {
					monthView(prevMonth, height: monthHeight, geo: geo)
						.offset(y: -monthHeight + dragOffset)
						.opacity(dragOffset > 0 ? 1.0 : 0.0)
				}

				// 현재 월
				monthView(selectedMonth, height: monthHeight, geo: geo)
					.offset(y: dragOffset)
					.opacity(1.0 - min(1.0, abs(dragOffset) / monthHeight) * 0.3)
					.scaleEffect(1.0 - min(1.0, abs(dragOffset) / monthHeight) * 0.05)

				// 다음 월
				if hasNextMonth {
					monthView(nextMonth, height: monthHeight, geo: geo)
						.offset(y: monthHeight + dragOffset)
						.opacity(dragOffset < 0 ? 1.0 : 0.0)
				}
			}
			.clipped()
			.simultaneousGesture(
				// 드래그 제스처 - 캘린더 월 변경 스크롤 (확대되지 않은 상태에서만)
				DragGesture()
					.onChanged { value in
						if isZoomedIn == false {
							let translation = value.translation.height
							// 드래그 오프셋 업데이트
							dragOffset = translation
							// 방향 감지 및 데이터 로드
							if translation > 50 {
								scrollDirection = .up
								if store.daysList[prevMonth] == nil {
									store.send(.viewAction(.setDaysList(prevMonth)))
								}
							} else if translation < -50 {
								scrollDirection = .down
								if store.daysList[nextMonth] == nil {
									store.send(.viewAction(.setDaysList(nextMonth)))
								}
							} else {
								scrollDirection = .none
							}
						} else {
							// 확대 상태 페이징 처리
							let translation = value.translation.height

							// 스크롤이 맨 위에 있고 아래로 드래그하는 경우
							if isScrollAtTop && translation > 0 {
								dragOffset = translation
								if translation > 50 && store.daysList[prevMonth] == nil {
									store.send(.viewAction(.setDaysList(prevMonth)))
								}
							}
							// 스크롤이 맨 아래에 있고 위로 드래그하는 경우
							else if isScrollAtBottom && translation < 0 {
								dragOffset = translation
								if translation < -50 && store.daysList[nextMonth] == nil {
									store.send(.viewAction(.setDaysList(nextMonth)))
								}
							}
						}
					}
					.onEnded { value in
						if isZoomedIn == false {
							let translation = value.translation.height
							let velocity = value.predictedEndTranslation.height - translation
							let threshold = monthHeight * 0.3  // 화면의 30% 이상 드래그하면 페이지 전환
							if translation > threshold || velocity > 50 {
								// 이전 월로 변경
								if store.daysList[prevMonth] != nil {
									dragOffset = monthHeight  // 애니메이션으로 완전히 이동
											store.send(.viewAction(.setSelectedMonth(prevMonth)))
											store.send(.viewAction(.setSelectedDay(nil)))
											dragOffset = 0
								} else {
									dragOffset = 0
								}
							} else if translation < -threshold || velocity < -50 {
								// 다음 월로 변경
								if store.daysList[nextMonth] != nil {
									dragOffset = -monthHeight  // 애니메이션으로 완전히 이동
											store.send(.viewAction(.setSelectedMonth(nextMonth)))
											store.send(.viewAction(.setSelectedDay(nil)))
											dragOffset = 0
								} else {
									dragOffset = 0
								}
							} else {
								// 원위치로 돌아가기
								dragOffset = 0
							}
							scrollDirection = .none
						} else {
							// 확대 상태 페이징 처리
							let translation = value.translation.height
							// 스크롤 맨 위에서 아래로 드래그
							if isScrollAtTop && translation > 100 {
								if store.daysList[prevMonth] != nil {
									// 이전 월로 전환하고 스크롤을 맨 아래로
									store.send(.viewAction(.setSelectedMonth(prevMonth)))
									store.send(.viewAction(.setSelectedDay(nil)))
									forceScrollToBottom = true
									isScrollAtTop = false
									isScrollAtBottom = false
								}
							}
							// 스크롤 맨 아래에서 위로 드래그
							else if isScrollAtBottom && translation < -100 {
								if store.daysList[nextMonth] != nil {
									// 다음 월로 전환하고 스크롤을 맨 위로
									store.send(.viewAction(.setSelectedMonth(nextMonth)))
									store.send(.viewAction(.setSelectedDay(nil)))
									forceScrollToTop = true
									isScrollAtTop = false
									isScrollAtBottom = false
								}
							}
							// 스크롤 상태 초기화
							dragOffset = 0
							targetWeekIndex = 0
							isScrollAtTop = false
							isScrollAtBottom = false

						}
					}
				)
		}
	}

	// 월 뷰
	@ViewBuilder
	private func monthView(_ month: String, height: CGFloat, geo: GeometryProxy) -> some View {
		VStack(spacing: 0) {
			if let weeks = store.daysList[month] {
				ForEach(Array(weeks.enumerated()), id: \.offset) { weekIndex, days in
					weekView(days: days, weekIndex: weekIndex, month: month, totalWeeks: weeks.count, height: height)
						.frame(height: height / CGFloat(weeks.count))
						.scaleEffect(CGSize(
							width: 1.0,
							height: isPinching ?
								(weekIndex == targetWeekIndex ? currentPinchScale : 1.0) :
								1.0
						))
						.opacity(
							isPinching ?
								(weekIndex == targetWeekIndex ? 1.0 : max(0.3, 1.0 - (currentPinchScale - 1.0) * 0.5)) :
								1.0
						)
				}
			} else {
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
		.background(Color.background)
		.overlay(
			PinchGestureView(
				onChanged: { scale, center in
					if !isZoomedIn && scale > 1.1 {
						// 핀치 시작 시 위치 저장
						if !isPinching {
							isPinching = true
							pinchStartLocation = center

							// 주차 계산
							if let weeks = store.daysList[month] {
								let weekHeight = height / CGFloat(weeks.count)
								targetWeekIndex = min(max(0, Int(center.y / weekHeight)), weeks.count - 1)
							}
						}

						// 실시간 스케일 업데이트
						currentPinchScale = scale

						// 특정 임계값을 넘으면 확대 모드로 전환
						if scale > 1.5 && !isZoomedIn {
							withAnimation(.spring(response: 0.4, dampingFraction: 0.85, blendDuration: 0)) {
								isZoomedIn = true
								zoomScale = 2.5
							}
						}
					}
				},
				onEnded: { scale, center in
					isPinching = false
					currentPinchScale = 1.0

					// 제스처 종료 시 확대가 안 되었다면 리셋
					if !isZoomedIn && scale > 1.1 {
						withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
							currentPinchScale = 1.0
						}
					}
				}
			)
		)
	}


	// 주 단위 뷰
	private func weekView(days: [CalendarDay], weekIndex: Int, month: String, totalWeeks: Int, height: CGFloat) -> some View {
		VStack(spacing: 0) {
			// 날짜 표시
			HStack(spacing: 0) {
				ForEach(days, id: \.self) { day in
					dateView(day)
						.frame(maxWidth: .infinity)
				}
			}

			// 이벤트 표시
			let dateHeight = CGFloat(totalWeeks) * (Constants.dateLabelHeight + 16)
			let cellHeight = (height - dateHeight) / CGFloat(totalWeeks)
			let count = max(1, Int(cellHeight / Constants.eventLabelHeight))

			Grid(horizontalSpacing: .zero, verticalSpacing: .zero) {
				ForEach(0..<count, id: \.self) { row in
					GridRow {
						ForEach(days, id: \.self) { day in
							eventCell(day: day, row: row, col: day.weekIndex, count: count)
								.frame(height: Constants.eventLabelHeight)
								.padding(.bottom, Constants.eventCellHPadding)
								.opacity(day.isPast ? Constants.eventCellOpacityPast : Constants.eventCellOpacity)
						}
					}
				}
			}
		}
	}

	// 컨텍스트 메뉴 뷰
	private var contextMenuView: some View {
		ContextMenu(
			show: $contextMenuShow,
			position: contextMenuPosition
		) {
			VStack(spacing: Constants.contextItemVSpacing) {
				contextMenuItem("월간", mode: .month)
				contextMenuItem("주간", mode: .week)
				contextMenuItem("일간", mode: .day)
				Divider()
				contextMenuItem("일정", mode: .schedule)
				Divider()
				contextMenuSwitch("담당업무", isOn: false)
			}
			.padding(.horizontal)
			.frame(width: Constants.contextItemWidth)
		}
	}

	private func contextMenuItem(_ title: String, mode: CalendarMode) -> some View {
		Button {
			store.send(.changeAction(.updateMode(mode)))
			contextMenuShow.toggle()
		} label: {
			HStack(spacing: Constants.contextItemHSpacing) {
				Image(systemName: "calendar")
					.renderingMode(.template)
					.foregroundStyle(store.state.mode == mode ? Color.accentColor : Color.primary)
				Text(title)
					.font(.subheadline.weight(.semibold))
					.foregroundStyle(store.state.mode == mode ? Color.accentColor : Color.primary)
					.lineLimit(Constants.lineCount)
				Spacer()
				Image(systemName: "checkmark")
					.renderingMode(.template)
					.foregroundStyle(store.state.mode == mode ? Color.accentColor : .clear)
			}
			.padding(.horizontal)
		}
	}

	private func contextMenuSwitch(_ title: String, isOn: Bool) -> some View {
		Toggle(isOn: Binding(
			get: { store.state.isShowTaskMode },
			set: { store.send(.changeAction(.updateTaskMode($0))) }
		)) {
			Text(title)
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(Color.primary)
				.lineLimit(Constants.lineCount)
		}
		.toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
		.padding(.horizontal)
	}

	// 캘린더 헤더
	private var headerView: some View {
		VStack {
			NavigationBar(
				title: store.selectedMonth,
				rightItems: [
					NavigationBarItem(iconView: AnyView(
						HStack(spacing: .zero) {
							Text(store.state.mode.name)
								.font(.body)
							Image(systemName: "chevron.down")
								.foregroundColor(Color.primary)
								.modifier(ContextMenu.SetPopupPosition($contextMenuPosition))
						}
							.frame(width: Constants.contextMenuWidth, height: Constants.contextMenuHeight)
							.background(
								RoundedRectangle(cornerRadius: Constants.contextMenuCornerRadius)
									.stroke(Color.secondary.opacity(0.3))
							)
					)) {
						contextMenuShow.toggle()
					},
					NavigationBarItem(iconView: AnyView(Image(systemName: "magnifyingglass"))) {
						// ...
					},
					NavigationBarItem(iconView: AnyView(Image(systemName: "bell"))) {
						// ...
					},
				],
				onMenu: {
					store.send(.viewAction(.setShowSideMenu(true)))
				}
			)
			.background(BlurEffect())

			// 요일 표시
			HStack {
				ForEach(Date.getWeekday(), id: \.self) { day in
					Text(day)
						.font(.headline.bold())
						.frame(maxWidth: .infinity)
				}
			}
		}
		.background(Color.gray.opacity(0.1))
	}

	// 날짜 텍스트
	private func dateView(_ day: CalendarDay) -> some View {
		Group {
			if day.day == 1 {   // 매월 1일
				Text("\(day.date.monthDayShort)")
			} else {
				Text("\(day.day)")
			}
		}
		.font(.caption)
		.lineLimit(Constants.lineCount)
		.foregroundStyle(dayTextColor(day))
		.background(
			Circle()
				.fill(day.isToday ? Color.blue.opacity(0.2) : .clear)
				.frame(width: Constants.dateLabelHeight, height: Constants.dateLabelHeight)
		)
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.vertical, Constants.dateTextPadding)
		.onTapGesture {
			// 날짜 선택 액션
			store.send(.viewAction(.setSelectedDay(day.date.yearMonthDay)))
		}
	}

	private func dayTextColor(_ day: CalendarDay) -> Color {
		if !day.isInMonth {
			return Color.secondary.opacity(0.5)   // 이전/이후 월
		} else if day.isPast {
			return Color.secondary.opacity(0.5)   // 오늘 이전
		} else if day.isToday {
			return Color.white      // 오늘
		} else if day.isWeekend {
			return Color.secondary.opacity(0.5)   // 주말
		} else {
			return Color.primary      // 평일
		}
	}

	// 이벤트 셀
	@ViewBuilder
	private func eventCell(day: CalendarDay, row: Int, col: Int, count: Int) -> some View {
		// 현재 주의 모든 이벤트에서 해당 위치에 맞는 이벤트 검색
		if let events = store.visibleEvents[day.date.yearMonthDay] {
			// 카운트 레이블 표시
			if row >= count - 1 && events.count > count {
				let remain = events.count - count + 1
				countLabel(remain)
			}
			// 이벤트 레이블 표시
			else {
				if let event = events.first(where: { event in row == event.rect.1 }) {
					switch event.rangeType {
						case .single:   // 단일 이벤트
							eventLabel(event)
								.padding(.horizontal, Constants.eventCellHPadding)
						case .start:    // 연속 이벤트 - 시작
							eventLabel(event)
								.gridCellColumns(event.rect.2)
								.padding(.horizontal, Constants.eventCellHPadding)
						case .middle:   // 연속 이벤트 - 중간: 다음 주로 이어지는 이벤트
							if col == 0 {
								eventLabel(event)
									.gridCellColumns(event.rect.2)
									.padding(.horizontal, Constants.eventCellHPadding)
							} else {
								EmptyView()
							}
						case .end:      // 연속 이벤트 - 끝: 표시하지 않음
							EmptyView()
					}
				} else {    // 빈 이벤트
					Color.clear
				}
			}
		} else {
			Color.clear
		}
	}

	// 이벤트 레이블
	private func eventLabel(_ event: CalendarEvent) -> some View {
		// Set View Modifier Flag
		let showBullet = event.rangeType == .single || event.rangeType == .start
		let showTaskLabel = event.rangeType != .single
		let showStartBorder = event.rangeType == .single || event.rangeType == .start
		let showEndBorder = event.rangeType == .single || event.rangeType == .middle
		return GeometryReader { proxy in
			Text(event.title)
				.font(.caption)
				.foregroundStyle(event.textColor)
				.frame(width: proxy.size.width + Constants.textClippingMargin, alignment: .leading)
		}
		.padding(.vertical, Constants.eventTextPadding)
		.modifier(EventBulletModifier(event: event, isShow: showBullet))
		.modifier(EventLabelModifier(event: event, isShowTaskLabel: showTaskLabel))
		.modifier(EventBorderModifier(isLeading: showStartBorder, isTrailing: showEndBorder))
	}

	// 카운트 레이블
	private func countLabel(_ count: Int) -> some View {
		HStack {
			Spacer()
			Text("+\(count)")
				.font(.caption)
				.scaleEffect(0.8)   // TODO: Font.Label.xs2_m 보다 작은 폰트 필요해서 scaleEffect로 반영
				.foregroundStyle(Color.white)
				.padding(Constants.eventTextPadding)
				.background(Color.gray)
				.cornerRadius(Constants.eventLabelCornerRadius)
				.padding(Constants.eventLabelPadding)
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
						.padding(.leading, Constants.eventLabelPadding)
				case .busy, .free, .closed, .canceled:
					HStack(spacing: Constants.eventBulletSpacing) {
						Capsule()
							.frame(width: Constants.eventBulletWidth, height: Constants.eventBulletHeight)
							.foregroundStyle(isShow ? event.textColor : .clear)
							.padding(.leading, Constants.eventBulletPadding)
						content
					}
				case .secret:
					HStack(spacing: Constants.eventBulletSpacing) {
						Image(systemName: "exclamationmark.circle.fill")
							.resizable()
							.renderingMode(.template)
							.foregroundStyle(isShow ? event.textColor : .clear)
							.frame(width: Constants.eventIconSize, height: Constants.eventIconSize)
							.padding(.leading, Constants.eventBulletPadding)
						content
					}
				case .task:
					HStack(spacing: Constants.eventBulletSpacing) {
						// TODO: 이미지 에셋 교체 - 다이아몬드 불릿이 필요함
						Image(systemName: "diamond.fill")
							.resizable()
							.renderingMode(.template)
							.foregroundStyle(isShow ? event.textColor : .clear)
							.frame(width: Constants.eventIconSize, height: Constants.eventIconSize)
							.padding(.leading, Constants.eventBulletPadding)
						content
					}
			}
		}
	}

	// Label - 이벤트 레이블의 배경 처리
	struct EventLabelModifier: ViewModifier {
		let event: CalendarEvent
		let isShowTaskLabel: Bool   // 이벤트가 .task에 하루(.single)가 아니면 레이블 표시
		func body(content: Content) -> some View {
			switch event.scheduleType {
				case .allDay, .busy, .secret:
					content
						.background(event.labelColor)
				case .free:
					content
						.background(
							HatchingEffect(color: event.textColor.opacity(Constants.eventLabelBGOpacity))
								.background(event.labelColor)
						)
				case .closed:
					content
						.background(event.labelColor)
						.overlay(
							RoundedRectangle(cornerRadius: Constants.eventLabelCornerRadius)
								.strokeBorder(event.textColor, style: StrokeStyle(lineWidth: Constants.eventLabelDashWidth, dash: Constants.eventLabelDashInterval))
						)
				case .canceled:
					content
						.strikethrough(true, color: event.textColor)
						.background(event.labelColor)
						.overlay(
							RoundedRectangle(cornerRadius: Constants.eventLabelCornerRadius)
								.stroke(event.textColor, style: StrokeStyle(lineWidth: Constants.eventLabelDashWidth, dash: Constants.eventLabelDashInterval))
						)
						.opacity(Constants.eventLabelCancelOpacity)
				case .task:
					content
						.background(isShowTaskLabel ? event.labelColor : .clear)
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
				.padding(.leading, isLeading ? Constants.activePadding : Constants.inactivePadding)
				.padding(.trailing, isTrailing ? Constants.activePadding : Constants.inactivePadding)
		}
	}

	struct RoundedShape: Shape {
		func path(in rect: CGRect) -> Path {
			return RoundedRectangle(cornerRadius: Constants.eventLabelCornerRadius).path(in: rect)
		}
	}

	struct RightRoundedShape: Shape {
		func path(in rect: CGRect) -> Path {
			let radius: CGFloat = Constants.eventLabelCornerRadius
			var path = Path()
			path.move(to: CGPoint(x: rect.minX, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
			path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
						radius: radius,
						startAngle: .degrees(Constants.rotateMinus90),
						endAngle: .degrees(Constants.rotateZero),
						clockwise: false)
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
			path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
						radius: radius,
						startAngle: .degrees(Constants.rotateZero),
						endAngle: .degrees(Constants.rotate90),
						clockwise: false)
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
			path.closeSubpath()
			return path
		}
	}

	struct LeftRoundedShape: Shape {
		func path(in rect: CGRect) -> Path {
			let radius: CGFloat = Constants.eventLabelCornerRadius
			var path = Path()
			path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
			path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
						radius: radius,
						startAngle: .degrees(Constants.rotateMinus90),
						endAngle: .degrees(Constants.rotateMinus180),
						clockwise: true)
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
			path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
						radius: radius,
						startAngle: .degrees(Constants.rotateMinus180),
						endAngle: .degrees(Constants.rotateMinus270),
						clockwise: true)
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
			path.closeSubpath()
			return path
		}
	}
}

extension CalendarMainView {
	private var drawerMenu: some View {
		ZStack(alignment: .leading) {
			// 사이드 메뉴 배경
			Color.black.opacity(0.5)
				.ignoresSafeArea()
				.onTapGesture {
					store.send(.viewAction(.setShowSideMenu(false)))
				}

			// 사이드 메뉴
			CalendarSideMenuView(store: store.scope(state: \.menuState, action: \.menuAction))
				.frame(width: Constants.sideMenuWidth)
				.background(Color.background)
				.transition(.move(edge: .leading))
		}
	}
}

// MARK: - UI Constatns
extension CalendarMainView {
	private struct Constants {
		static let contextMenuCornerRadius = CGFloat(30)
		static let contextMenuWidth = CGFloat(53)
		static let contextMenuHeight = CGFloat(30)
		static let contextItemWidth = CGFloat(180)
		static let contextItemVSpacing = CGFloat(24)
		static let contextItemHSpacing = CGFloat(10)

		static let eventCellHPadding = CGFloat(2)
		static let eventCellOpacity = CGFloat(1.0)
		static let eventCellOpacityPast = CGFloat(0.6)

		static let dateTextPadding = CGFloat(5)
		static let dateLabelHeight = CGFloat(20)

		static let eventTextPadding = CGFloat(2)
		static let textClippingMargin = CGFloat(16)
		static let lineCount = 1

		static let gridBaseHeight = CGFloat(540)
		static let gridPageUpPadding = CGFloat(84)
		static let gridPageDownPadding = CGFloat(244)

		static let countLabelHeight = CGFloat(13)
		static let eventLabelHeight = CGFloat(16)
		static let eventLabelPadding = CGFloat(4)
		static let eventLabelCornerRadius = CGFloat(4)
		static let eventLabelDashWidth = CGFloat(0.5)
		static let eventLabelDashInterval = [CGFloat(2.0), CGFloat(2.0)]
		static let eventLabelCancelOpacity = CGFloat(0.8)
		static let eventLabelBGOpacity = CGFloat(0.1)

		static let eventBulletPadding = CGFloat(2)
		static let eventBulletSpacing = CGFloat(2)
		static let eventBulletWidth = CGFloat(2)
		static let eventBulletHeight = CGFloat(10)
		static let eventIconSize = CGFloat(10)

		static let activePadding = CGFloat(1)
		static let inactivePadding = CGFloat(0)

		// 레이블 보더
		static let rotateZero = Double(0)
		static let rotate90 = Double(90)
		static let rotateMinus90 = Double(-90)
		static let rotateMinus180 = Double(-180)
		static let rotateMinus270 = Double(-270)

		// 핀치 제스처
		static let pinchBase = CGFloat(1.0)
		static let pinchLimit = CGFloat(1.8)

		// 페이지 스크롤 제스처
		static let dragChangeThreshold = CGFloat(80)
		static let dragEndThreshold = CGFloat(480)

		static let sideMenuWidth = CGFloat(240)

		static let animationDuration = CGFloat(0.4)
		static let animationDelay = 400
	}
}

// MARK: - HatchingEffect
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
				initialState: CalendarMainReducer.State(events: CalendarMainPreview.getCalendarEvent06()),
				reducer: { CalendarMainReducer() }
			)
		)
	}

	// TEST DATA
	static func getCalendarEvent06() -> [CalendarEvent] {
		[
			CalendarEvent(
				date: Date.from("2025.05.05"),
				endDate: nil,
				title: "부처님오신날",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),
			CalendarEvent(
				date: Date.from("2025.05.05"),
				endDate: nil,
				title: "어린이날",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),

			CalendarEvent(
				date: Date.from("2025.05.06"),
				endDate: nil,
				title: "어린이날(대체휴일)",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),

			CalendarEvent(
				date: Date.from("2025.06.03"),
				endDate: nil,
				title: "대통령 선거일",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),
			CalendarEvent(
				date: Date.from("2025.06.06"),
				endDate: nil,
				title: "현충일",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),

			CalendarEvent(
				date: Date.from("2025.06.25"),
				endDate: nil,
				title: "문화의 날",
				textColor: Color.purple,
				labelColor: Color.purple.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),

			CalendarEvent(
				date: Date.from("2025.06.04 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.04 11:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "D-TF 주간회의",
				textColor: Color.orange,
				labelColor: Color.orange.opacity(0.1),
				notes: "Daily sync meeting with team",
				location: "페이코룸",
				participants: ["앨리스", "밥", "찰리"],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.04 12:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.04 12:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "점심회식",
				textColor: Color.green,
				labelColor: Color.green.opacity(0.1),
				notes: "Daily sync meeting with team",
				location: "팔복",
				participants: ["앨리스", "밥", "찰리"],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.04 12:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.04 12:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "진행상황공유",
				textColor: Color.green,
				labelColor: Color.green.opacity(0.1),
				notes: "Daily sync meeting with team",
				location: "로비",
				participants: ["밥", "찰리"],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),

			CalendarEvent(
				date: Date.from("2025.06.05 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.05 15:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "프로덕트디자인",
				textColor: Color.cyan,
				labelColor: Color.cyan.opacity(0.1),
				notes: "",
				location: "컨퍼런스룸",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "[공유] 프로덕트디자인1팀",
			),
			CalendarEvent(
				date: Date.from("2025.06.05 16:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.05 16:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "시안공유",
				textColor: Color.indigo,
				labelColor: Color.indigo.opacity(0.1),
				notes: "",
				location: "컨퍼런스룸",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] 프로덕트디자인1팀",
			),
			CalendarEvent(
				date: Date.from("2025.06.5 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.5 17:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "시안공유",
				textColor: Color.green,
				labelColor: Color.green.opacity(0.1),
				notes: "Sprint planning for Q3",
				location: "8-0",
				participants: ["제품팀"],
				scheduleType: .canceled,
				rect: (0, 0, 0, 0),
				category: "[공유] 프로덕트디자인1팀",
			),

			CalendarEvent(
				date: Date.from("2025.06.09 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.09 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "10월2주",
				textColor: Color.mint,
				labelColor: Color.mint.opacity(0.1),
				notes: "스프린트",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.09 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.09 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "D-TF 주간회의",
				textColor: Color.cyan,
				labelColor: Color.cyan.opacity(0.1),
				notes: "회의",
				location: "Zoom",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.09 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.09 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "[북토크]도망친 나라에 안식은 없다",
				textColor: Color.teal,
				labelColor: Color.teal.opacity(0.1),
				notes: "활동",
				location: "Zoom",
				participants: [],
				scheduleType: .closed,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.09 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.09 17:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "방향성 보고",
				textColor: Color.brown,
				labelColor: Color.brown.opacity(0.1),
				notes: "",
				location: "8-3",
				participants: ["루키"],
				scheduleType: .canceled,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),

			CalendarEvent(
				date: Date.from("2025.06.10 18:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.10 19:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "프로덕트디자인",
				textColor: Color.pink,
				labelColor: Color.pink.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] 프로덕트디자인1팀",
			),

			CalendarEvent(
				date: Date.from("2025.06.11 18:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.11 19:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "프로덕트디자인",
				textColor: Color.green,
				labelColor: Color.green.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] 프로덕트디자인1팀",
			),

			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.13"),
				title: "[휴가] 조예리",
				textColor: Color.yellow,
				labelColor: Color.yellow.opacity(0.1),
				notes: "개인사유",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.13"),
				title: "플레이뮤지엄 리뉴얼",
				textColor: Color.blue,
				labelColor: Color.blue.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .free,
				rect: (0, 0, 0, 0),
				category: "NHN 디자인실",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.12"),
				title: "직무교육",
				textColor: Color.gray,
				labelColor: Color.gray.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.12"),
				title: "D! K/O 1",
				textColor: Color.teal,
				labelColor: Color.teal.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.12"),
				title: "D! K/O 2",
				textColor: Color.teal,
				labelColor: Color.teal.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.12"),
				title: "D! K/O 3",
				textColor: Color.teal,
				labelColor: Color.teal.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.12"),
				title: "D! K/O 4",
				textColor: Color.teal,
				labelColor: Color.teal.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.12"),
				title: "D! K/O 5",
				textColor: Color.teal,
				labelColor: Color.teal.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),
			CalendarEvent(
				date: Date.from("2025.06.12"),
				endDate: Date.from("2025.06.12"),
				title: "D! K/O 6",
				textColor: Color.teal,
				labelColor: Color.teal.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] D-TF",
			),

			CalendarEvent(
				date: Date.from("2025.06.17 18:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.17 19:59:59", format: "yyyy.MM.dd HH:mm:ss"),
				title: "프로덕트디자인",
				textColor: Color.purple,
				labelColor: Color.purple.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .busy,
				rect: (0, 0, 0, 0),
				category: "[공유] 프로덕트디자인1팀",
			),

			CalendarEvent(
				date: Date.from("2025.06.24 08:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 09:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 1",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 09:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 2",
				textColor: Color.green,
				labelColor: Color.green.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 3",
				textColor: Color.orange,
				labelColor: Color.orange.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 12:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 13:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 4",
				textColor: Color.mint,
				labelColor: Color.mint.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 13:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 5",
				textColor: Color.gray,
				labelColor: Color.gray.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 6",
				textColor: Color.pink,
				labelColor: Color.pink.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 7",
				textColor: Color.cyan,
				labelColor: Color.cyan.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 16:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 8",
				textColor: Color.cyan,
				labelColor: Color.cyan.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
			CalendarEvent(
				date: Date.from("2025.06.24 16:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				endDate: Date.from("2025.06.24 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
				title: "교육 9",
				textColor: Color.cyan,
				labelColor: Color.cyan.opacity(0.1),
				notes: "교육",
				location: "Zoom",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
		]
	}
	static func getCalendarEvent07() -> [CalendarEvent] {
		[
			CalendarEvent(
				date: Date.from("2025.07.30"),
				endDate: nil,
				title: "문화의 날",
				textColor: Color.purple,
				labelColor: Color.purple.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),

			CalendarEvent(
				date: Date.from("2025.07.17"),
				endDate: Date.from("2025.07.21"),
				title: "연속 이벤트 - 1. Hello, world.",
				textColor: Color.indigo,
				labelColor: Color.indigo.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Waplat-Project",
			),

			CalendarEvent(
				date: Date.from("2025.07.18"),
				endDate: Date.from("2025.07.02"),
				title: "연속 이벤트 - 2. It's no use crying over spilt milk.",
				textColor: Color.orange,
				labelColor: Color.orange.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Waplat-Project",
			),

			CalendarEvent(
				date: Date.from("2025.07.23"),
				endDate: Date.from("2025.07.28"),
				title: "연속 이벤트 - 3. Life goes on.",
				textColor: Color.brown,
				labelColor: Color.brown.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .task,
				rect: (0, 0, 0, 0),
				category: "Waplat-Project",
			),
		]
	}
	static func getCalendarEvent08() -> [CalendarEvent] {
		[
			CalendarEvent(
				date: Date.from("2025.08.15"),
				endDate: nil,
				title: "광복절",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),
			CalendarEvent(
				date: Date.from("2025.08.27"),
				endDate: nil,
				title: "문화의 날",
				textColor: Color.purple,
				labelColor: Color.purple.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
		]
	}
	static func getCalendarEvent09() -> [CalendarEvent] {
		[
			CalendarEvent(
				date: Date.from("2025.09.24"),
				endDate: nil,
				title: "문화의 날",
				textColor: Color.purple,
				labelColor: Color.purple.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
		]
	}
	static func getCalendarEvent10() -> [CalendarEvent] {
		[
			CalendarEvent(
				date: Date.from("2025.10.03"),
				endDate: nil,
				title: "개천절",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),
			CalendarEvent(
				date: Date.from("2025.10.04"),
				endDate: Date.from("2025.10.08"),
				title: "추석",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),
			CalendarEvent(
				date: Date.from("2025.10.09"),
				endDate: nil,
				title: "한글날",
				textColor: Color.red,
				labelColor: Color.red.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "대한민국 휴일",
			),
			CalendarEvent(
				date: Date.from("2025.10.29"),
				endDate: nil,
				title: "문화의 날",
				textColor: Color.purple,
				labelColor: Color.purple.opacity(0.1),
				notes: "",
				location: "",
				participants: [],
				scheduleType: .allDay,
				rect: (0, 0, 0, 0),
				category: "Dooray!",
			),
		]
	}
}
#endif
