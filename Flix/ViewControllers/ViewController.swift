//
//  ViewController.swift
//  Flix
//
//  Created by Saad Mahboob on 24/09/2020.

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() //create a new array of dictionary
    var filteredMovies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.endEditing(true)
        requestData()
    }
    
    //functionality of being able to search movies.
    //below 3 functions are to reisgn the keyboard when any one of the following happens
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    //this function filters data and adds the searched movies into a new list to load on table
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMovies = []
        
        if (searchText == "" ){
            filteredMovies = movies
        }
        else{
            for movie in movies{
                let title = movie["title"] as! String
                if( title.lowercased().contains(searchText.lowercased()) ){
                    filteredMovies.append(movie)
                }
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    //these are the table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w185/"
        let path = movie["poster_path"] as! String
        let posterURL = URL (string: baseURL + path)
        
        cell.titleLabel.text = title
        cell.descriptionLabel.text = overview
        cell.posterImage.af.setImage(withURL: posterURL!)
        
        return cell
    }
    
    
    //this function is calling the api and loading the movies information from the endpoint
    func requestData(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           }
           else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let typeCheck = type(of: dataDictionary)
            print("type \(typeCheck)")
                self.movies = dataDictionary["results"] as! [[String : Any]]
                filteredMovies = movies
                self.tableView.reloadData()
           }
        }
        
        task.resume()
    }
    
    
    //this is passing the movies information to the detailed view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Find the movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movieSelected = movies[indexPath.row]
        
        //Send the movie detail
        
        let detailViewController = segue.destination as! MovieDetailViewController
        detailViewController.movie = movieSelected
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
