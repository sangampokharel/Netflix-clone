//
//  SearchViewController.swift
//  Netflix
//
//  Created by sangam pokharel on 13/10/2023.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    var searchTimer: Timer? = nil
    @IBOutlet weak var searchCV: UICollectionView!
    
    @IBOutlet weak var searchTxt: UITextField!{
        didSet{
            let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
            searchIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
            searchIcon.contentMode = .center
            searchIcon.tintColor = .white
            
            // Create a padding view with the desired width
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: searchTxt.frame.size.height))
            paddingView.addSubview(searchIcon)
            
            // Set the leftView of the UITextField to the padding view
            searchTxt.leftView = paddingView
            searchTxt.leftViewMode = .always
            
            // Set corner radius
            searchTxt.layer.cornerRadius = 10
            
            
            
        }
    }
    private let searchViewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCV.dataSource = self
        searchCV.delegate = self
        
        searchTxt.delegate = self
        
        
        
    }
    
    
    
    
    
    
}

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModel.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        cell.searchImageView.sd_setImage(with: URL(string: "\(API.IMAGE_BASE_URL)\(searchViewModel.searchResults[indexPath.row].posterPath ?? "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg")"))
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3  - 10, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = navigationController?.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.movieDetail = searchViewModel.searchResults[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
}

extension SearchViewController:UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTimer?.invalidate()
        
        // Start a new timer with a 1-second delay
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            // This closure will be called after a 1-second delay
            if let searchText = self?.searchTxt.text {
                self?.searchViewModel.searchMovies(query: searchText){[weak self] in
                    self?.searchCV.reloadData()
                    
                }
            }
            
        }
        
        return true
    }
}
