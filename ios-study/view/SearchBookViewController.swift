//
//  ViewController.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/21.
//

import UIKit

class SearchBookViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchResult: BookListResponse?
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defultQuery = "mongodb"
        searchBar.text = defultQuery
        requestSearchAPI(query: defultQuery, page: 1)
                                        
    }
    
    private func pushBookDetailViewController(item: BookListItem) {
        performSegue(withIdentifier: "segueBookDetail", sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? BookDetailViewController {
            let bookItem = sender as? BookListItem
            viewController.bundleDate = bookItem
        }
    }
    
}

extension SearchBookViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
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
        if indexPath.row == (searchResult?.books?.count ?? 0) - 1,
           searchResult?.total ?? 0 > searchResult?.books?.count ?? 0,
           let page = searchResult?.page,
           let query = searchBar.text {
            requestSearchAPI(query: query, page: page + 1)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = searchResult?.books?[indexPath.row] {
            pushBookDetailViewController(item: item)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            requestSearchAPI(query: text, page: 1)
        }
    }
    
}

extension SearchBookViewController {
    
    private func requestSearchAPI(query: String, page: Int) {
        guard !isLoading else {
            return
        }
        isLoading = true
        ItbookAPIImpl.shared.search(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let result):
                if result.page ?? 1 == 1 {
                    self?.searchResult = result
                } else {
                    self?.searchResult?.page = result.page
                    self?.searchResult?.books?.append(contentsOf: result.books ?? [])
                }
            case .failure(let error):
                self?.searchResult = nil
                debugPrint("ERROR : " + error.localizedDescription)
            case .none:
                self?.searchResult = nil
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            self?.isLoading = false
        }
    }
    
}
