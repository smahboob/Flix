//
//  MovieDetailViewController.swift
//  Flix
//
//  Created by Saad Mahboob on 28/09/2020.
//

import UIKit
import AlamofireImage


class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var movie: [String:Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let date = movie["release_date"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let baseURLCover = "https://image.tmdb.org/t/p/w780"
        let path = movie["poster_path"] as! String
        let posterURL = URL (string: baseURL + path)
        let backDropPath = movie["backdrop_path"] as! String
        let backdropURL = URL (string: baseURLCover + backDropPath)
        
        self.title = title
        movieName.text = title
        movieName.sizeToFit()
        releaseDate.text = date
        releaseDate.sizeToFit()
        descriptionLabel.text = overview
        descriptionLabel.sizeToFit()
        profilePhoto.af.setImage(withURL: posterURL!)
        coverPhoto.af.setImage(withURL: backdropURL!)
        
    }
}
