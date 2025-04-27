//
//  MailNotifySheet.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

struct MailNotifySheet: View {
	private enum NotifyType: CaseIterable {
		case spam, hacking
		var name: String {
			switch self {
				case .spam:
					return "스팸신고"
				case .hacking:
					return "해킹 의심 신고"
			}
		}
	}
	
	@State private var selectedNoti: NotifyType = .spam
	@State private var text: String = ""
	
	var body: some View {
		VStack {
			Capsule()
				.fill(Color.secondary)
				.frame(width: 40, height: 4)
				.padding(.top, 8)
				.padding(.bottom, 20)
			
			HStack {
				ForEach(NotifyType.allCases, id: \.self) { option in
					ZStack {
						Text(option.name)
							.foregroundStyle(
								selectedNoti == option ? Color.primary : Color.secondary
							)
							.onTapGesture {
								withAnimation {
									selectedNoti = option
								}
							}
						
						if selectedNoti == option {
							Rectangle()
								.frame(width: selectedNoti == .spam ? 64 : 103)
								.frame(height: 4)
								.offset(y: 20)
						}
					}
					.id(option)
				}
				Spacer()
			}
			.padding(.horizontal, 24)
			
			Divider()
				.padding(.horizontal, 24)
				.padding(.bottom, 20)
			
			VStack {
				if selectedNoti == .spam {
					notifySpamContent
				} else {
					notifyHackingContent
				}
			}
			.padding(.horizontal, 24)
			
			Spacer()
		}
		.presentationDetents([.fraction(selectedNoti == .spam ? 0.48 : 0.64)])
		.animation(.easeInOut(duration: 0.4), value: selectedNoti)
	}
	
	var notifySpamContent: some View {
		VStack(alignment: .leading) {
			Text("해당 메일 주소를 수신 차단하며 차단된 메일은 Dooray!로 전달됩니다.")
				.foregroundStyle(Color.primary)
				.padding(.bottom, 16)
			
			Button {
				// ...
			} label: {
				HStack {
					Image.init(systemName: "checkmark.circle.fill")
						.renderingMode(.template)
						.foregroundStyle(Color.accentColor)
					Text("이전에 받은 메일에도 적용")
						.foregroundColor(Color.primary)
				}
			}
			.padding(.bottom, 16)
			
			Button {
				// ...
			} label: {
				HStack {
					Image.init(systemName: "checkmark.circle.fill")
						.renderingMode(.template)
						.foregroundStyle(Color.accentColor)
					Text("해당 주소 수신 차단")
						.foregroundColor(Color.primary)
				}
			}
			.padding(.bottom, 8)
			
			Text("해킹 의심으로 신고하면 관리자에게 전달되며 신고된 메일은 자동으로 스팸 메일함으로 이동합니다.")
				.foregroundColor(Color.secondary)
				.padding(.bottom, 20)
			
			HStack {
				Button {
					// ...
				} label: {
					Text("취소")
						.tint(.secondary)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Color.secondary, lineWidth: 2)
								.background(Color.white.cornerRadius(16))
						)
				}
				
				Button {
					// ...
				} label: {
					Text("신고")
						.tint(.primary)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Color.secondary, lineWidth: 2)
								.background(Color.white.cornerRadius(16))
						)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
	}
	
	var notifyHackingContent: some View {
		VStack(alignment: .leading) {
			VStack {
				// TODO: 텍스트 에디터 플레이스홀더 표시
				// "신고 사유를 200자 이내로 작성해주세요"
				TextEditor(text: $text)
					.frame(height: 150)
					.background(Color.secondary)
					.cornerRadius(16)
					.onChange(of: text) { old, new in
						if new.count > 200 {
							text = String(new.prefix(200))
						}
					}
				
				HStack(spacing: 0) {
					Spacer()
					Text("\(text.count)")
						.foregroundColor(Color.primary)
					
					Text("/200")
						.foregroundColor(Color.secondary)
				}
				.padding()
			}
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color.secondary, lineWidth: 1)
			)
			.padding(.bottom, 16)
			
			Button {
				// ...
			} label: {
				HStack {
					Image.init(systemName: "checkmark.circle.fill")
						.renderingMode(.template)
						.foregroundStyle(Color.accentColor)
					Text("해당 주소 수신 차단")
						.foregroundColor(Color.primary)
				}
			}
			.padding(.bottom, 8)
			
			Text("해킹 의심으로 신고하면 관리자에게 전달되며 신고된 메일은 자동으로 스팸 메일함으로 이동합니다.")
				.foregroundColor(Color.secondary)
				.padding(.bottom, 20)
			
			HStack {
				Button {
					// ...
				} label: {
					Text("취소")
						.tint(.secondary)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Color.secondary, lineWidth: 2)
								.background(Color.white.cornerRadius(16))
						)
				}
				
				Button {
					// ...
				} label: {
					Text("신고")
						.tint(.primary)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Color.secondary, lineWidth: 2)
								.background(Color.white.cornerRadius(16))
						)
				}
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
	}
}

#Preview {
	MailNotifySheet()
}
