//
//  SuperheroDetailViewController.swift
//  Flix
//
//  Created by Saad Mahboob on 30/09/2020.
//

import UIKit

class SuperheroDetailViewController: UIViewController {
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    var movie: [String:Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSupeHeroData()
    }
    

    func loadSupeHeroData(){
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let releaseDate = movie["release_date"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let baseURLCover = "https://image.tmdb.org/t/p/w780"
        let path = movie["poster_path"] as! String
        let posterURL = URL (string: baseURL + path)
        let backDropPath = movie["backdrop_path"] as! String
        let backdropURL = URL (string: baseURLCover + backDropPath)
        
        self.title = title
        movieTitle.text = title
        movieTitle.sizeToFit()
        date.text = releaseDate
        date.sizeToFit()
        detailLabel.text = overview
        detailLabel.sizeToFit()
        profilePhoto.af.setImage(withURL: posterURL!)
        coverPhoto.af.setImage(withURL: backdropURL!)
    }

}
