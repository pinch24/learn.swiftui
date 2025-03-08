//
//  DragProperties.swift
//  FlashCards
//
//  Created by Mk on 3/7/25.
//

import SwiftUI
import CoreData

class DragProperties: ObservableObject {
    /// Drag Preview Properties
	@Published var show: Bool = false
	@Published var previewImage: UIImage?
	@Published var initialViewLocation: CGPoint = .zero
	@Published var updatedViewLocation: CGPoint = .zero
	/// Gesture Properties
	@Published var offset: CGSize = .zero
	@Published var location: CGPoint = .zero
	/// For Grouping and Section Re-Ordering
	@Published var sourceCard: FlashCard?
	@Published var sourceCategory: Category?
	@Published var destinationCategory: Category?
	@Published var isCardsSwapped: Bool = false
	
	func changeGroup(_ context: NSManagedObjectContext) {
		guard let sourceCard, let destinationCategory else { return }
		
		sourceCard.order = destinationCategory.nextOrder
		sourceCard.category = destinationCategory
		
		try? context.save()
		resetAllProperties()
	}
	
	func swapCardsInSameGroup(_ destinationCard: FlashCard) {
		guard let sourceCard else { return }
		
		let sourceIndex = sourceCard.order
		let destinationIndex = destinationCard.order
		
		/// Swapping Orders
		sourceCard.order = destinationIndex
		destinationCard.order = sourceIndex
		
		isCardsSwapped = true
	}
	
	/// Reset's all properties
	func resetAllProperties() {
		self.show = false
		self.previewImage = nil
		self.initialViewLocation = .zero
		self.updatedViewLocation = .zero
		self.offset = .zero
		self.location = .zero
		self.sourceCard = nil
		self.sourceCategory = nil
		self.destinationCategory = nil
		self.isCardsSwapped = false
	}
}

extension Category {
	var nextOrder: Int32 {
		let allCards = cards?.allObjects as? [FlashCard] ?? []
		let lastOrderValue = allCards.max(by: { $0.order < $1.order })?.order ?? 0
		return lastOrderValue + 1
	}
}
