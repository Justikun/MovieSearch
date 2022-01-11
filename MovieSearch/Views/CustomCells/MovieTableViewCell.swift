//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Justin Lowry on 1/7/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    // MARK: - Properties
    var movie: Movies.MovieData? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Methods
    func updateViews() {
        guard let movie = movie else { return }
        titleLabel.text = movie.title
        ratingLabel.text = "Rating: \(movie.rating)"
        overviewLabel.text = movie.overview
        
        MovieController.fetchPosterImage(forPath: movie.posterPath) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.posterImage.image = image
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                }
            }
        }
    }
}
