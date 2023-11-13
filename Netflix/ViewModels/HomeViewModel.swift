//
//  HomeViewModel.swift
//  Netflix
//
//  Created by sangam pokharel on 14/10/2023.
//

import Foundation

class HomeViewModel {
    
    static let shared = HomeViewModel()
    
    var nowPlayingMovies = [Movie]()
    var upComingMovies = [Movie]()
    var topRatedMovies = [Movie]()
    var popularMovies = [Movie]()
    
    
    
    
    func getNowPlayingMovies(completion:@escaping ()->Void){
        ApiServices.shared.getNowPlayingMovies { result in
            switch result {
                
            case .success(let result):
                DispatchQueue.main.async{[weak self] in
                    self?.nowPlayingMovies.append(contentsOf: result)
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getUpComingMovies(completion:@escaping ()->Void){
        ApiServices.shared.getUpcomingMovies { result in
            switch result {
                
            case .success(let result):
                DispatchQueue.main.async {[weak self] in
                    self?.upComingMovies.append(contentsOf: result)
                    completion()
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPopularMovies(completion:@escaping ()->Void){
        ApiServices.shared.getPopularMovies { result in
            switch result {
                
            case .success(let result):
                DispatchQueue.main.async {[weak self] in
                    self?.popularMovies.append(contentsOf: result)
                    completion()
                    
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getTopRatedMovies(completion:@escaping () -> Void){
        ApiServices.shared.getTopRatedMovies { result in
            switch result {
                
            case .success(let result):
                DispatchQueue.main.async {[weak self] in
                    
                    self?.topRatedMovies.append(contentsOf: result)
                    completion()
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}
