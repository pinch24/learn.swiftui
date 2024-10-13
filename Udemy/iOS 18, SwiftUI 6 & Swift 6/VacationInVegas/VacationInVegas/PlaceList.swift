//
//  PlaceList.swift
//  VacationInVegas
//
//  Created by MK on 10/13/24.
//

import SwiftUI
import SwiftData

struct PlaceList: View {
    @Query(sort: \Place.name) private var places: [Place]
    
    @State private var showImages = false
    @State private var searchText = ""
    @State private var filterByInterested = false
    
    private var predicate: Predicate<Place> {
        #Predicate<Place> {
            if searchText.isEmpty == false && filterByInterested {
                $0.name.localizedStandardContains(searchText) && $0.interested
            }
            else if searchText.isEmpty == false {
                $0.name.localizedStandardContains(searchText)
            }
            else if filterByInterested {
                $0.interested
            }
            else {
                true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List((try? places.filter(predicate)) ?? places) { place in
                HStack {
                    place.image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 7))
                        .frame(width: 100, height: 100)
                    
                    Text(place.name)
                    
                    Spacer()
                    
                    if place.interested {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .padding(.trailing)
                    }
                }
            }
            .navigationTitle("Places")
            .searchable(text: $searchText, prompt: "Find a Place")
            .animation(.default, value: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Show Images", systemImage: "photo") {
                        showImages.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Filter", systemImage: filterByInterested ? "star.fill" : "star") {
                        withAnimation {
                            filterByInterested.toggle()
                        }
                    }
                    .tint(filterByInterested ? .yellow : .blue)
                }
            }
            .sheet(isPresented: $showImages) {
                Scrolling()
            }
        }
    }
}

#Preview {
    PlaceList()
        .modelContainer(Place.preview)
}
