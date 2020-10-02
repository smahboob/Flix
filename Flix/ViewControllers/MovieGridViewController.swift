//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Saad Mahboob on 28/09/2020.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: (width*3)/2)
        
        fetchAPIData()
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    func fetchAPIData(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           }
           else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            
                self.movies = dataDictionary["results"] as! [[String : Any]]
                self.collectionView.reloadData()
           }
        }
        
        task.resume()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        
        let movie = movies[indexPath.item]
        let baseURL = "https://image.tmdb.org/t/p/w185/"
        let path = movie["poster_path"] as! String
        let posterURL = URL (string: baseURL + path)
        cell.posterImage.af.setImage(withURL: posterURL!)
        cell.posterImage.layer.cornerRadius =  10
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movieSelected = movies[indexPath.row]
                    
        let detailViewController = segue.destination as! SuperheroDetailViewController
        detailViewController.movie = movieSelected
        
    }

}
