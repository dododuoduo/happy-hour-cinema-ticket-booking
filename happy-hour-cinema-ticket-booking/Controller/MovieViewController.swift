//
//  MovieViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit
import FirebaseAuth

class MovieViewController: UIViewController {
    
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var myTicketButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var doctorStrangeButton: UIButton!
    @IBOutlet weak var badGuyButton: UIButton!
    @IBOutlet weak var batManButton: UIButton!
    @IBOutlet weak var sonicButton: UIButton!
    
    var selectedMovieId: String?
    var selectedMovieName: String?
    var selectedYear: String?
    var selectedMovieDescription: String?
    var selectedRating: Double?
    var movies: [Movie] = []
    
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MovieViewController works!")
        self.initMovieView()
    }
    
    func initMovieView() {
        Style.styleFilledButton(myTicketButton)
        Style.styleFilledButton(logoutButton)
        firstnameLabel.alpha = 0
        firstnameLabel.layer.backgroundColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1).cgColor
        firstnameLabel.layer.cornerRadius = 20
        firstnameLabel.textColor = .white
        self.renderUsername()
        self.getMovies()
    }
    
    //get movies infomation from Rapid API
    func getMovies() {
        let headers = [
            "X-RapidAPI-Host": "movie-database-alternative.p.rapidapi.com",
            "X-RapidAPI-Key": "7761e23771msh3616a95a9f2e8f3p1b075ejsne64a6146940d"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://movie-database-alternative.p.rapidapi.com/?s=love&r=json&y=2021&page=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        var movieResponse: [NSDictionary] = []
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse != nil && httpResponse!.statusCode == 200) {
                    //JSON Prase for movies response
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                        movieResponse = json["Search"] as! [NSDictionary]
                        for index in 0..<movieResponse.count{
                            var movie = Movie(movieId: nil, movieName: nil, year: nil, movieDescription: nil, movieRating: nil)
                            movie.movieId = movieResponse[index]["imdbID"] as? String
                            movie.movieName = movieResponse[index]["Title"] as? String
                            movie.year = movieResponse[index]["Year"] as? String
                            self.movies.insert(movie, at: index)
                        }
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func renderUsername() {
        let user = Auth.auth().currentUser
        if user == nil {
            return
        }
        
        let uid = user!.uid
        self.db.getFirstname(uid: uid) { (firstname) in
            self.firstnameLabel.text = firstname
            self.firstnameLabel.alpha = 1
        }
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Cannot signout")
            return
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onDoctorStrangeTapped(_ sender: Any) {
        self.selectedMovieId = self.movies[0].movieId
        self.selectedMovieName = self.movies[0].movieName
        self.selectedYear = self.movies[0].year
        self.selectedMovieDescription = "An LA girl, unlucky in love, falls for an East Coast guy on a dating app and decides to surprise him for the holidays, only to discover that she's been catfished. This lighthearted romantic comedy chronicles her attempt to reel in love."
        self.selectedRating = 6.3
        self.navToOrderDetails()
    }
    
    @IBAction func onBadGuyTapped(_ sender: Any) {
        self.selectedMovieId = self.movies[1].movieId
        self.selectedMovieName = self.movies[1].movieName
        self.selectedYear = self.movies[1].year
        self.selectedMovieDescription = "Love, Scandal and Doctors is a story of 5 medical interns who got embroiled in a scandal. They are the prime accused in a murder. The question lies - Are these students even capable of committing such a crime or are they just being framed?"
        self.selectedRating = 5.9
        self.navToOrderDetails()
    }
    
    @IBAction func onBatManTapped(_ sender: Any) {
        self.selectedMovieId = self.movies[2].movieId
        self.selectedMovieName = self.movies[2].movieName
        self.selectedYear = self.movies[2].year
        self.selectedMovieDescription = "A young woman, on the run after 10 years in a suffocating marriage to a tech billionaire, suddenly realizes that her husband has implanted a revolutionary monitoring device in her brain that allows him to track her every move."
        self.selectedRating = 6.9
        self.navToOrderDetails()
    }
    
    @IBAction func onSonicTapped(_ sender: Any) {
        self.selectedMovieId = self.movies[3].movieId
        self.selectedMovieName = self.movies[3].movieName
        self.selectedYear = self.movies[3].year
        self.selectedMovieDescription = "Erica, who ends up as the entertainment at her ex-fiancé's wedding after reluctantly taking a gig at a luxurious island resort while in the wake of a music career meltdown."
        self.selectedRating = 5.7
        self.navToOrderDetails()
    }
    
    @objc func navToOrderDetails() {
        self.performSegue(withIdentifier: "movieToOrderDetails", sender: nil)
    }
    
    // pass booking id to the order details controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "movieToOrderDetails") {
            if let destinationVC = segue.destination as? OrderDetailsViewController {
                destinationVC.movieId = self.selectedMovieId
                destinationVC.movieName = self.selectedMovieName
                destinationVC.movieDescription = self.selectedMovieDescription
                destinationVC.movieRating = self.selectedRating!
            }
        }
    }
    
}
