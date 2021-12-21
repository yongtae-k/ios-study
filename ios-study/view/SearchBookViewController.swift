//
//  ViewController.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
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
        bookImageView.image = nil
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


class SearchBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchResult: BookListResponse?
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        requestSearchAPI(query: "mongodb", page: 0)
                                        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? BookDetailViewController {
            let bookItem = sender as? BookListItem
            viewController.bundleDate = bookItem
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.books?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookTableViewCell", for: indexPath) as? SearchBookTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = searchResult?.books?[indexPath.row] {
            cell.updateUI(item: item)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = searchResult?.books?[indexPath.row]
        performSegue(withIdentifier: "segueBookDetail", sender: item)
    }
    
    func requestSearchAPI(query: String, page: Int) {
        ItbookAPIImpl.shared.search(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let result):
                self?.searchResult = result
            case .failure(let error):
                self?.searchResult = nil
                debugPrint("ERROR : " + error.localizedDescription)
            case .none:
                self?.searchResult = nil
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
    }
}

