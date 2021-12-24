//
//  View.swift
//  ios-study
//
//  Created by 김용태 on 2021/12/24.
//

import UIKit

extension UIImageView {
    func getImage(url: URL) {
        let imageTag = url.path
        DownloadImage.shared.getImage(url: url) {[weak self] result in
            switch result {
            case .success(let result):
                if imageTag == imageTag {
                    DispatchQueue.main.async {
                        self?.image = result
                    }
                } else {
                    debugPrint("PASS : " + url.path)
                }
            case .failure(let error):
                debugPrint("ERROR : " + error.localizedDescription)
            case .none:
                debugPrint("NONE : ")
            }
        }
    }
}
