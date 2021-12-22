//
//  SearchBookTableViewCell.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/22.
//

import UIKit

class SearchBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var isbn13Label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    func updateUI(item: BookListItem) {
        if let urlStirng = item.image, let url = URL(string: urlStirng) {
            DownloadURL.shared.getImage(url: url) {[weak self] result in
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
        titleLabel.text = item.title
        subTitleLabel.text = item.subtitle
        isbn13Label.text = item.isbn13
        priceLabel.text = item.price
        urlLabel.text = item.url
    }
    
    override func prepareForReuse() {
        bookImageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
        isbn13Label.text = nil
        priceLabel.text = nil
        urlLabel.text = nil
    }
}
