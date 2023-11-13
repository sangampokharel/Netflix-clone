//
//  DetailsViewController.swift
//  Netflix
//
//  Created by sangam pokharel on 14/10/2023.
//

import UIKit
import YouTubeiOSPlayerHelper

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var headerImageView:UIImageView!
    var movieDetail:Movie? = nil
    
    @IBOutlet weak var downloadBtn: UIButton!{
        didSet{
            downloadBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movieDetail {
            movieName.text = movie.originalTitle
            movieOverview.text = movie.overview
            
            headerImageView.sd_setImage(with: URL(string: "\(API.IMAGE_BASE_URL)\(movie.posterPath ?? "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg")"))
            
        }
        
    }
    
    
    @IBAction func handleDownload(_ sender: Any) {
        if let movieInfo = movieDetail {
            DataManager().downloadMovie(movie:movieInfo){result in
                switch result {
                    
                case .success(_):
                    self.showToast(message: "Movie Downloaded Successfully", font: .systemFont(ofSize: 12.0))
                  
                    NotificationCenter.default.post(name: Notification.Name("DownloadSuccess"), object: nil, userInfo: [:])
                case .failure(let error):
                    
                    print(error)
                }
            }
            
            
        }
    }
    
}
