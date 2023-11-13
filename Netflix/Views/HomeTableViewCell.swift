//
//  HomeTableViewCell.swift
//  Netflix
//
//  Created by sangam pokharel on 12/10/2023.
//

import UIKit
import SDWebImage

protocol NavigateFromCollectionViewDelegate:AnyObject {
    func handleCollectionViewClicked(_ indexPath:IndexPath,movie:Movie)
}
protocol DisplayToastMessageDelegate:AnyObject {
    func displayToast()
}

class CollectionViewImageCell:UICollectionViewCell {
    
    @IBOutlet weak var movieImageView:UIImageView!{
        didSet{
            movieImageView.layer.cornerRadius = 10
        }
    }
    
  
    
}

class HomeTableViewCell: UITableViewCell {
    weak var navigationDelegate:NavigateFromCollectionViewDelegate? = nil
   
    weak var displayToastDelegate:DisplayToastMessageDelegate? = nil
    private var movie = [Movie]()
    
    @IBOutlet weak var horizontalCollectionView: UICollectionView!{
        didSet{
            self.horizontalCollectionView.dataSource = self
            self.horizontalCollectionView.delegate = self
        }
    }
    
    
    func config(movie:[Movie]){
        self.movie = movie
        DispatchQueue.main.async{[weak self] in
            
            self?.horizontalCollectionView.reloadData()
            
        }
    }
    
    
    func downloadMovie(indexPath:IndexPath){
        DataManager.shared.downloadMovie(movie: self.movie[indexPath.row]){result in
            switch result {
                
            case .success(_):
                // fire notification to retrive data
                self.displayToastDelegate?.displayToast()
                NotificationCenter.default.post(name: Notification.Name("DownloadSuccess"), object: nil, userInfo: [:])
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    
    
    
}

extension HomeTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate {
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleMoviesCollectionCell", for: indexPath) as! CollectionViewImageCell
        cell.movieImageView.sd_setImage(with: URL(string: "\(API.IMAGE_BASE_URL)\(self.movie[indexPath.row].posterPath ?? "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg")"), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationDelegate?.handleCollectionViewClicked(indexPath,movie: self.movie[indexPath.row])
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self]  _ in
            let downloadAction = UIAction(title: "Download", state: .off) {_ in
                self?.downloadMovie(indexPath: indexPath)
            }
            
            return UIMenu(options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
  
    
   
    
}
