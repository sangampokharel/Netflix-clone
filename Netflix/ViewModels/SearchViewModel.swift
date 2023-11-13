//
//  SearchViewModel.swift
//  Netflix
//
//  Created by sangam pokharel on 15/10/2023.
//

import Foundation

class SearchViewModel{
    
    var searchResults = [Movie]()
    
    func searchMovies(query:String,completion: @escaping ()->Void){
        ApiServices.shared.searchMovies(query: query) { result in
            switch result {
                
            case .success(let result):
                DispatchQueue.main.async {[weak self] in
                    self?.searchResults = result.filter { !($0.posterPath?.isEmpty ?? true) }
                    completion()
                }
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
}
