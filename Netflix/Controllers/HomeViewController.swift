//
//  HomeViewController.swift
//  Netflix
//
//  Created by sangam pokharel on 12/10/2023.
//

import UIKit
import SDWebImage
class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var playBtn: UIButton!{
        didSet{
            playBtn.layer.cornerRadius = 10
            playBtn.layer.borderWidth = 2
            playBtn.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var headerImageView: UIImageView!{
        didSet{
            let CAGradient = CAGradientLayer()
            CAGradient.frame = headerImageView.bounds
            CAGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            CAGradient.locations = [0.5,1.0]
            headerImageView.layer.insertSublayer(CAGradient, at: 0)
        
        }
    }
    @IBOutlet weak var downloadBtn: UIButton!{
        didSet{
            downloadBtn.layer.cornerRadius = 10
            downloadBtn.layer.borderWidth = 2
            downloadBtn.layer.borderColor = UIColor.white.cgColor
            
        }
    }
    let sectionTitle = ["Now Playing","Popular","Upcoming","TopRated"]
    
    private let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        configureNavigationBar()
        
        
         
    }
    
    
    func configureNavigationBar(){
        let titleInBar = UIBarButtonItem(title: "NETFLIX", style: .done, target: self, action: nil)
        titleInBar.tintColor = UIColor.systemRed
        
        navigationItem.leftBarButtonItem = titleInBar
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
            
        ]
        
    }
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource,NavigateFromCollectionViewDelegate {
    func handleCollectionViewClicked(_ indexPath: IndexPath, movie: Movie) {
        let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.movieDetail = movie
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! HomeTableViewCell
        cell.navigationDelegate = self
        cell.displayToastDelegate = self
        
        
        switch indexPath.section {
        case MoviesInformation.nowPlaying.rawValue:
            homeViewModel.getNowPlayingMovies{[weak self] in
                
                self?.headerImageView.sd_setImage(with: URL(string: "\(API.IMAGE_BASE_URL)\(self?.homeViewModel.nowPlayingMovies.randomElement()?.posterPath ?? "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg")"))
                cell.config(movie: self?.homeViewModel.nowPlayingMovies ?? [])
            }
            
        case MoviesInformation.popular.rawValue:
            homeViewModel.getPopularMovies{[weak self] in
                
                cell.config(movie:  self?.homeViewModel.popularMovies ?? [])
            }
            
        case MoviesInformation.topRated.rawValue:
            
            homeViewModel.getTopRatedMovies{[weak self] in
                cell.config(movie:  self?.homeViewModel.topRatedMovies ?? [])
            }
            
        case MoviesInformation.upComing.rawValue:
            homeViewModel.getUpComingMovies{[weak self] in
                cell.config(movie: self?.homeViewModel.upComingMovies ?? [])
            }
            
        default:
            cell.config(movie: [])
        }
        
        
        
        return cell
    }
    
    // single row max height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.text = sectionTitle[section]
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    
}

extension HomeViewController : DisplayToastMessageDelegate {
    func displayToast() {
        self.showToast(message: "Movie Downloaded Successfully", font: .systemFont(ofSize: 14))
    }
    
    
}
