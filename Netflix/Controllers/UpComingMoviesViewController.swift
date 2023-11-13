//
//  UpComingMoviesViewController.swift
//  Netflix
//
//  Created by sangam pokharel on 13/10/2023.
//

import UIKit

class UpComingMoviesCell:UITableViewCell {
    @IBOutlet weak var movieTitle:UILabel!
    @IBOutlet weak var movieImage:UIImageView!

}

class UpComingMoviesViewController: UIViewController {

    @IBOutlet weak var upComingMoviesTableView: UITableView!
    
    private let homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        upComingMoviesTableView.delegate = self
        upComingMoviesTableView.dataSource = self
        
        homeViewModel.getUpComingMovies {[weak self] in
            self?.upComingMoviesTableView.reloadData()
        }
    }
    


}

extension UpComingMoviesViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.upComingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingMoviesCell", for: indexPath) as!  UpComingMoviesCell
        
        cell.movieTitle.text = homeViewModel.upComingMovies[indexPath.row].title
        
        cell.movieImage.sd_setImage(with: URL(string: "\(API.IMAGE_BASE_URL)\(homeViewModel.upComingMovies[indexPath.row].backdropPath ?? "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg")"))
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = navigationController?.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.movieDetail = homeViewModel.upComingMovies[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
