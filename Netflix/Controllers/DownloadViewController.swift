//
//  DownloadViewController.swift
//  Netflix
//
//  Created by sangam pokharel on 15/10/2023.
//

import UIKit

class DownloadViewController: UIViewController {

    @IBOutlet weak var downloadedTableView: UITableView!
    
    private var downloadedMovies = [MovieItem]()
    override func viewDidLoad() {
        super.viewDidLoad()

        listenNotificationCenter()
        
        handleNotification()
        
        downloadedTableView.dataSource = self
        downloadedTableView.delegate = self
        
    }
    
   @objc func handleNotification(){
       DataManager.shared.fetchDownloads{result in
           switch result {
               
           case .success(let movies):
               DispatchQueue.main.async {[weak self] in
                   self?.downloadedMovies = movies
                   self?.downloadedTableView.reloadData()
             
               }
               
               
           case .failure(let error):
               print(error.localizedDescription)
           }
       }
    }
    
    func listenNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("DownloadSuccess") , object: nil)
    }
    

    func deleteItem(indexPath:IndexPath){
        let data = downloadedMovies[indexPath.row]
        DataManager().deleteDownloads(movie: data)
        
        self.showToast(message: "Movie Deleted Successfully", font: .systemFont(ofSize: 12.0))
    }

}

extension DownloadViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadedMovieCell", for: indexPath) as! DownloadedMovieCell
        
        cell.movieTitle.text = downloadedMovies[indexPath.row].originalTitle
        cell.movieImage.sd_setImage(with: URL(string: "\(API.IMAGE_BASE_URL)\(downloadedMovies[indexPath.row].posterPath ?? "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg")"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            deleteItem(indexPath: indexPath)
            downloadedMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
