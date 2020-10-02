//
//  MovieDetailViewController.swift
//  Flix
//
//  Created by Saad Mahboob on 28/09/2020.
//

import UIKit
import AlamofireImage
import SafariServices

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie: [String:Any]!
    var trailerMovie = [[String:Any]]()
    var id: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        profilePhoto.layer.borderWidth = 1.5
        profilePhoto.layer.borderColor = UIColor.white.cgColor
        loadData()
    }
    
    @IBAction func playTrailer(_ sender: Any) {
        
        var link: String!
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           }
           else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
                self.trailerMovie = dataDictionary["results"] as! [[String : Any]]
                let index = self.trailerMovie[0]
                let key = index["key"] as! String
                link = "https://www.youtube.com/watch?v=\(key)"
                let vc = SFSafariViewController(url: URL(string: link)!)
                present(vc, animated: true)
            
           }
        }
        
        task.resume()
        
        
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
        id = movie["id"] as! Int

        
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
