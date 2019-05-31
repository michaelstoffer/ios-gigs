//
//  GigController.swift
//  Gigs
//
//  Created by Michael Stoffer on 5/28/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noEncode
    case noDecode
}

class GigController {
    var gigs: [Gig] = []
    
    var bearer: Bearer?
    
    static let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = GigController.baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let loginURL = GigController.baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            
            guard let data = data else { completion(NSError()); return }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = self.bearer else { completion(.failure(.noAuth)); return }
        
        let allGigsURL = GigController.baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                NSLog("Getting 401 error!")
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            do {
                let gigs = try decoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding animal objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createGig(withTitle title: String, withDescription description: String, withDueDate dueDate: Date, completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = self.bearer else { completion(.failure(.noAuth)); return }
        let gig = Gig(title: title, description: description, dueDate: dueDate)
        
        let createGigURL = GigController.baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding gig object: \(NSError())")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }

            if let _ = error {
                completion(.failure(.otherError))
                return
            }

            self.gigs.append(gig)
            completion(.success(self.gigs))
        }.resume()
    }
}
