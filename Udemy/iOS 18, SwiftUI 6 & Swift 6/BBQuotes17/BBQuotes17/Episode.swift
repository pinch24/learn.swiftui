//
//  Episode.swift
//  BBQuotes17
//
//  Created by MK on 10/17/24.
//

import Foundation

struct Episode: Decodable {
	let episode: Int	// 101
	let title: String
	let image: URL
	let synopsis: String
	let writtenBy: String
	let directedBy: String
	let airDate: String
	
	var seasonEpisode: String {
		var episodeString = String(episode)						// 101
		let season = episodeString.removeFirst()				// return 1
		
		if episodeString.first == "0" {
			episodeString = String(episodeString.removeLast())	// return 1
		}
		
		return "Season \(season) Episode \(episodeString)"		// 1, 1
	}
}
