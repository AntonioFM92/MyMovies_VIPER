//
//  MovieCell.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 27/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MovieCell: UITableViewCell {
    
    private let leftMargin: CGFloat = 15
    private let lineHeight: CGFloat = 10
    
    static let heightCell: CGFloat = 130
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x = leftMargin
            frame.size.width = UIScreen.main.bounds.size.width - 2 * leftMargin
            frame.size.height -= lineHeight
            
            super.frame = frame
        }
    }
    
    func setCellValues(movieImage: String, movieTitle: String, movieYear: String){
        guard let movieImageURL = URL(string: Utilities.checkImageUrl(imageURL: movieImage)) else {
            return
        }
        self.movieImageView.sd_setImage(with: movieImageURL, placeholderImage: UIImage(named: "noposter"))
        
        self.movieTitleLabel.text = movieTitle
        self.movieYearLabel.text = movieYear
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.movieTitleLabel.text = ""
        self.movieYearLabel.text = ""
        self.movieImageView.image = nil
    }
}

