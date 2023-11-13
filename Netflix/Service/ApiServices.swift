//
//  ApiServices.swift
//  Netflix
//
//  Created by sangam pokharel on 13/10/2023.
//

import Foundation

struct API {
     static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
     static let BASE_URL = "https://api.themoviedb.org"
     static let IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w500"
    
}
final class ApiServices {
    static let shared = ApiServices()
    
    private init(){
        
    }
    
    func getNowPlayingMovies(completion: @escaping (Result<[Movie],Error>) -> Void){
        guard let url = URL(string:"\(API.BASE_URL)/3/movie/now_playing?language=en-US&page=1&api_key=\(API.API_KEY)" ) else {return}
        
      
        
        URLSession.shared.dataTask(with: url) { data, response, error in
       
            guard let data = data , error == nil else {return}

            do{
                
                let json = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(json.results ?? []))
                
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            
            
            
        }.resume()
    }
    
    func getUpcomingMovies(completion : @escaping (Result<[Movie], Error>)->Void ){

        guard let url = URL(string: "\(API.BASE_URL)/3/movie/upcoming?language=en-US&page=1&api_key=\(API.API_KEY)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            
            do{
                let json = try JSONDecoder().decode(MovieResponse.self, from: data)
               
                completion(.success(json.results ?? []))
                
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }.resume()
        
        
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>)->Void){
        
        guard let url = URL(string: "\(API.BASE_URL)/3/movie/popular?language=en-US&page=1&api_key=\(API.API_KEY)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            
            do {
                let json = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(json.results ?? []))
            }catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(API.BASE_URL)/3/movie/top_rated?language=en-US&page=1&api_key=\(API.API_KEY)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            
            do {
                let json = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(json.results ?? []))
            }catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    // search movies
    
    func searchMovies(query:String,completion : @escaping (Result<[Movie], Error>)->Void){
     
        guard let url = URL(string:"\(API.BASE_URL)/3/search/movie?query=\(query)&include_adult=false&language=en-US&page=1&api_key=\(API.API_KEY)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {return}
            
            do {
                let json = try JSONDecoder().decode(MovieResponse.self, from: data)
               
                completion(.success(json.results ?? []))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
}
