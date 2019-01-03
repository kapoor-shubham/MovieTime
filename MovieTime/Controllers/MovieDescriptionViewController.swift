//
//  MovieDescriptionViewController.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 03/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDescriptionViewController: UIViewController {
    
    //    MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userRatingButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabelHeightAnchor: NSLayoutConstraint!
    
    //    MARK:- Objects & Properties
    var moviesModel = TrendingMoviesModel()
    let movieDescriptionViewModel = MoviesDescriptionViewModel()
    var resource: ImageResource?

    //    MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUIUpdate()
        userRatingButton.layer.borderColor = UIColor(red: 226/255, green: 150/255, blue: 32/255, alpha: 1.0).cgColor
        userRatingButton.layer.borderWidth = 2.0
    }
    
    //    MARK:- UIButton Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingsButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Rating", message: "Rate your movie here.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Ratings"
            textField.textAlignment = .center
        }
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            print("Text field: \(textField.text!)")
            self.sendUserRatings(rating: textField.text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func sendUserRatings(rating: String) {
        let ratingValue = Float(rating)
        movieDescriptionViewModel.sendRating(rating: ratingValue!, movieID: moviesModel.movieID!, responseModel: { (_, _, _) in
        })
    }
   
    //    MARK:- Private Helper Methods
    private func viewUIUpdate() {
        titleLabel.text = moviesModel.title
        titleLabelHeightAnchor.constant = heightForView(text: moviesModel.title!)
        self.view.updateConstraints()
        descriptionTextView.text = moviesModel.overview
        movieImageView.kf.setImage(with: resource)
    }
    
    private func heightForView(text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: titleLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = titleLabel.font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
