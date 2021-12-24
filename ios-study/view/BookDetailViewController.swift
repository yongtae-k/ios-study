//
//  BookDetailViewController.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    
    @IBOutlet weak var isbn10Label: UILabel!
    @IBOutlet weak var isbn13Label: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var pdfLabel: UILabel!
    
    var bundleDate: BookListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let bundleDate = bundleDate, let isbn13 = bundleDate.isbn13 else {
            return
        }
        updateUI(bundleDate: bundleDate)
        requestBookDetailAPI(isbn13: isbn13)
    }
    
    func updateUI(bundleDate: BookListItem) {
        title = bundleDate.title
        if let urlStirng = bundleDate.image, let url = URL(string: urlStirng) {
            DownloadImage.shared.getImage(url: url) {[weak self] result in
                switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self?.bookImageView.image = result
                    }
                case .failure(let error):
                    debugPrint("ERROR : " + error.localizedDescription)
                case .none:
                    debugPrint("NONE : ")
                }
            }
        }
        titleLabel.text = "title : \(bundleDate.title ?? "")"
        subtitleLabel.text = "subtitle : \(bundleDate.subtitle ?? "")"
        isbn10Label.text = "isbn13 : \(bundleDate.isbn13 ?? "")"
        priceLabel.text = "price : \(bundleDate.price ?? "")"
        imageLabel.text = "image : \(bundleDate.image ?? "")"
        urlLabel.text = "url : \(bundleDate.url ?? "")"
    }

    func updateUI(item: BookDetailResponse) {
        title = item.title
        if let urlStirng = item.image, let url = URL(string: urlStirng) {
            bookImageView.getImage(url: url)
        }
        titleLabel.text = "title : \(item.title ?? "")"
        subtitleLabel.text = "subtitle : \(item.subtitle ?? "")"
        authorsLabel.text = "authors : \(item.authors ?? "")"
        publisherLabel.text = "publisher : \(item.publisher ?? "")"
        
        isbn10Label.text = "isbn13 : \(item.isbn13 ?? "")"
        isbn13Label.text = "isbn10 : \(item.isbn10 ?? "")"
        pagesLabel.text = "pages : \(item.pages ?? "")"
        yearLabel.text = "year : \(item.year ?? "")"
        ratingLabel.text = "rating : \(item.rating ?? "")"
        
        descLabel.text = "desc : \(item.desc ?? "")"
        priceLabel.text = "price : \(item.price ?? "")"
        imageLabel.text = "image : \(item.image ?? "")"
        urlLabel.text = "url : \(item.url ?? "")"
        var pdf = "pdf info : \n"
        for (key,value) in item.pdf ?? [:] {
            pdf += "\(key) : \(value)\n"
        }
        pdfLabel.text = pdf
        
    }
    
    func requestBookDetailAPI(isbn13: String) {
        ItbookAPIImpl.shared.bookDetail(isbn13: isbn13) {[weak self] result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.updateUI(item: result)
                }
            case .failure(let error):
                debugPrint("ERROR : " + error.localizedDescription)
            case .none:
                debugPrint("NONE : ")
            }
        }
    }
    
}
