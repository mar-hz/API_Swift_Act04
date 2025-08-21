//
//  ViewModel.swift
//  Places

import Foundation

@Observable
@MainActor
class PlaceViewModel {
    
    var arrPlaces = [Place]()
    
    init() {
        
        arrPlaces = load("placesData.json")
        
        print(arrPlaces)
    }
    
        
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func loadAPI() async throws {
        
        guard let url = URL (string: "hhtps://tec-actions-test-production.up.railway.app/places" ) else { print("invalid url")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            print("error")
            return
        }
        
        let results = try JSONDecoder().decode([Place].self, from: data)
        
        self.arrPlaces = results
    }
    
}
