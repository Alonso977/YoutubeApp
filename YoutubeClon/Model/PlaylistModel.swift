//
//  PlaylistModel.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 15/11/22.
//

import Foundation

struct PlayList: Decodable {
    let kind, etag: String
    let pageInfo: PageInfo
    let items: [Items]
   
    
    struct Items: Decodable {
        let kind, etag, id: String
        let snippet: Snipet
        let contentDetails: ContentDetails

        struct Snipet: Decodable {
            let publishedAt,channelId,title,description: String
            let channelTitle: String
            let localized: Localized
            let thumbnails: Thumbnails
            
            struct Thumbnails: Decodable {
                let medium: Medium
                
                struct Medium: Decodable {
                    let url: String
                    let width: Int
                    let height: Int
                }
            }
            
            struct Localized: Decodable {
                let title,description: String
            }
            
        }// end of snippet
        
        struct ContentDetails: Decodable {
            let itemCount: Int
        }
        
    } // End of Items
    
    struct PageInfo: Decodable {
        let totalResults: Int
        let resultsPerPage: Int
    }
}
