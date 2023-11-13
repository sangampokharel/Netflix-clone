//
//  DataManager.swift
//  Netflix
//
//  Created by sangam pokharel on 15/10/2023.
//

import UIKit
class DataManager {
    
    static let shared = DataManager()
    
//    private init(){
//        
//    }
    
    func downloadMovie(movie:Movie,completion: @escaping (Result<Any,Error>)->()){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            
          let movieData = MovieItem(context: context)
            movieData.backdropPath = movie.backdropPath
            movieData.originalTitle = movie.originalTitle
            movieData.overview = movie.overview
            movieData.posterPath = movie.posterPath
            
            do{
                try context.save()
                completion(.success(()))
            }catch {
                completion(.failure(error))
                print (error.localizedDescription)
            }
        }

        
    }
    
    func fetchDownloads(completion: @escaping (Result<[MovieItem],Error>)-> Void){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            let request = MovieItem.fetchRequest()
            
            do{
                let downloadedMovies = try context.fetch(request)
                completion(.success(downloadedMovies))
            }catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
        }
    }
    
    func deleteDownloads(movie:MovieItem){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            context.delete(movie)
            do{
                try context.save()
              

            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
}
