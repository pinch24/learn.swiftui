//
//  SignUpView.swift
//  Notes
//
//  Created by Mk on 2/18/25.
//

import SwiftUI

struct SignUpView: View {
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var isPasswordVisible: Bool = false
	// Add these new state variables
	@State private var emailError: String? = nil
	@State private var passwordError: String? = nil
	@State private var animate: Bool = false
	
	var body: some View {
		VStack(spacing: 20) {
			// Title Section
			VStack(alignment: .leading, spacing: 8) {
				Text("Create an account")
					.font(.system(size: 22, weight: .bold))
					.foregroundColor(.white)
					.shadow(color: .black.opacity(0.5), radius: 60, y: 30)
					.opacity(animate ? 1 : 0)
					.offset(y: animate ? 0 : 20)
					.blur(radius: animate ? 0 : 10)
					.animation(.easeOut(duration: 0.5).delay(0.1), value: animate)
				
				Text("Begin your 30-day complimentary trial immediately.")
					.font(.system(size: 15))
					.foregroundColor(.white.opacity(0.7))
					.opacity(animate ? 1 : 0)
					.offset(y: animate ? 0 : 20)
					.blur(radius: animate ? 0 : 10)
					.animation(.easeOut(duration: 0.5).delay(0.2), value: animate)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			
			// Email Input
			VStack(alignment: .leading, spacing: 4) {
				HStack {
					TextField("Email address", text: $email)
						.font(.system(size: 15))
						.foregroundColor(.white.opacity(0.7))
						.autocapitalization(.none)
						.keyboardType(.emailAddress)
						.onChange(of: email) {
							validateEmail()
						}
					
					Button(action: {}) {
						Image(systemName: "envelope.fill")
							.font(.caption)
							.foregroundColor(.white)
							.frame(width: 28, height: 28)
							.background(
								Circle()
									.fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
									.overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
							)
					}
				}
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.background(Color.black.opacity(0.2))
				.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
				.cornerRadius(10)
				.opacity(animate ? 1 : 0)
				.offset(y: animate ? 0 : 20)
				.blur(radius: animate ? 0 : 10)
				.animation(.easeOut(duration: 0.5).delay(0.3), value: animate)
				
				if let error = emailError {
					Text(error)
						.font(.caption)
						.foregroundColor(.red)
						.padding(.horizontal, 4)
				}
			}
			
			// Password Input
			VStack(alignment: .leading, spacing: 4) {
				HStack {
					if isPasswordVisible {
						TextField("Password", text: $password)
							.font(.system(size: 15))
							.foregroundColor(.white.opacity(0.7))
					} else {
						SecureField("Password", text: $password)
							.font(.system(size: 15))
							.foregroundColor(.white.opacity(0.7))
					}
					
					Button(action: { isPasswordVisible.toggle() }) {
						Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
							.font(.caption)
							.foregroundColor(.white)
							.frame(width: 28, height: 28)
							.background(
								Circle()
									.fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
									.overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
							)
					}
				}
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.background(Color.black.opacity(0.2))
				.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
				.cornerRadius(10)
				.opacity(animate ? 1 : 0)
				.offset(y: animate ? 0 : 20)
				.blur(radius: animate ? 0 : 10)
				.animation(.easeOut(duration: 0.5).delay(0.4), value: animate)
				
				if let error = passwordError {
					Text(error)
						.font(.caption)
						.foregroundColor(.red)
						.padding(.horizontal, 4)
				}
			}
			
			// Forgot Password
			Button(action: {}) {
				Text("Forgot password")
					.font(.system(size: 15))
					.foregroundColor(.white)
					.frame(maxWidth: .infinity, alignment: .trailing)
			}
			.opacity(animate ? 1 : 0)
			.offset(y: animate ? 0 : 20)
			.blur(radius: animate ? 0 : 10)
			.animation(.easeOut(duration: 0.5).delay(0.5), value: animate)
			
			// Continue Button
			Button(action: validateAndSubmit) {
				HStack {
					Text("Continue")
						.font(.system(size: 17))
					Image(systemName: "chevron.right")
				}
				.foregroundColor(.white)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 10)
				.background(Color.blue)
				.cornerRadius(10)
			}
			.opacity(animate ? 1 : 0)
			.offset(y: animate ? 0 : 20)
			.blur(radius: animate ? 0 : 10)
			.animation(.easeOut(duration: 0.5).delay(0.6), value: animate)
			
			// Divider
			Rectangle()
				.fill(Color.white.opacity(0.1))
				.frame(height: 1)
				.opacity(animate ? 1 : 0)
				.offset(y: animate ? 0 : 20)
				.blur(radius: animate ? 0 : 10)
				.animation(.easeOut(duration: 0.5).delay(0.7), value: animate)
			
			// Google Sign Up Button
			Button(action: {}) {
				HStack {
					Text("Sign up with Google")
						.font(.system(size: 17))
					Spacer()
					Image(systemName: "g.circle.fill")
				}
				.foregroundColor(.white)
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
				.background(Color.white.opacity(0.1))
				.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
				.cornerRadius(10)
			}
			.opacity(animate ? 1 : 0)
			.offset(y: animate ? 0 : 20)
			.blur(radius: animate ? 0 : 10)
			.animation(.easeOut(duration: 0.5).delay(0.8), value: animate)
			
			// Apple Sign Up Button
			Button(action: {}) {
				HStack {
					Text("Sign up with Apple")
						.font(.system(size: 17))
					Spacer()
					Image(systemName: "apple.logo")
				}
				.foregroundColor(.white)
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
				.background(Color.white.opacity(0.1))
				.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
				.cornerRadius(10)
			}
			.opacity(animate ? 1 : 0)
			.offset(y: animate ? 0 : 20)
			.blur(radius: animate ? 0 : 10)
			.animation(.easeOut(duration: 0.5).delay(0.9), value: animate)
		}
		.padding(20)
		.background(
			LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
		)
		.overlay(
			RoundedRectangle(cornerRadius: 20)
				.stroke(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
		)
		.background(.ultraThinMaterial)
		.cornerRadius(20)
		.padding()
		.onAppear {
			withAnimation {
				animate = true
			}
		}
	}
	
	// Add these new functions
	private func validateEmail() {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
		if !emailPredicate.evaluate(with: email) {
			emailError = "Please enter a valid email address"
		} else {
			emailError = nil
		}
	}
	
	private func validatePassword() {
		if password.count < 8 {
			passwordError = "Password must be at least 8 characters long"
		} else {
			passwordError = nil
		}
	}
	
	private func validateAndSubmit() {
		validateEmail()
		validatePassword()
		
		if emailError == nil && passwordError == nil {
			// Perform sign up action here
			print("Sign up successful")
		}
	}
}
#Preview {
	SignUpView()
}
