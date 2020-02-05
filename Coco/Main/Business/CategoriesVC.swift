//
//  CategoriesVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var collection: UICollectionView!
  
  var loader: LoaderVC!
  var categories: Categories!
  var id_business: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    categories = Categories()
    configureCollection()
    requestData()
  }
  
  private func configureCollection() {
    collection.delegate = self
    collection.dataSource = self
    collection.showsHorizontalScrollIndicator = false
    collection.showsVerticalScrollIndicator = false
    collection.isPagingEnabled = false
    let nib = UINib(nibName: CategoriesCollectionViewCell.cellIdentifier,
                    bundle: nil)
    collection.register(nib,forCellWithReuseIdentifier: CategoriesCollectionViewCell.cellIdentifier)
  }
  
  private func requestData() {
    showLoader(&loader, view: view)
    categories.requestCategories { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.fillInfo()
      }
    }
  }
  
  private func fillInfo() {
    collection.reloadData()
  }
  
  @IBAction func backBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.categories.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collection.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.cellIdentifier, for: indexPath) as? CategoriesCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let item = categories.categories[indexPath.item]
    
    cell.categoryLabel.text = item.name
    cell.categoryImage.kf.setImage(with: URL(string: item.imageURL ?? ""),
                                   placeholder: nil,
                                   options: [.transition(.fade(0.4))],
                                   progressBlock: nil,
                                   completionHandler: nil)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = categories.categories[indexPath.item]
    let vc = ProductsVC()
    vc.id_business = id_business
    vc.id_category = item.id ?? ""
    presentAsync(vc)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = (UIScreen.main.bounds.width - 20) / 2
    return CGSize(width: size, height: size)
  }
}
