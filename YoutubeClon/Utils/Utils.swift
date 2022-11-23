//
//  Utils.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 22/11/22.
//

import Foundation

// Alonso: - Este se va encargar de leer el JSON y convertirlo en un tipo de dato especifico

class Utils{
    static func parseJson<T: Decodable>(jsonName: String, model: T.Type)-> T? {
        guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            do {
                let responseModel = try jsonDecoder.decode(T.self, from: data)
                return responseModel
            } catch {
                print("json mock Error: \(error)")
                return nil
            }
        }catch {
            return nil
        }
    }
}
