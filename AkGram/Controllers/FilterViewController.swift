//
//  FilterViewController.swift
//  AkGram
//
//  Created by Amg on 19/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

//MARK: - Protocol Update Photo
protocol FilterViewControllerDelegate {
    func updatePhoto(_ imageFilter: UIImage)
}

class FilterViewController: UIViewController {
    //MARK: - Vars
    var filterImage: UIImage?
    let context = CIContext(options: nil)
    var delegate: FilterViewControllerDelegate?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterImageView.image = filterImage
    }
    
    //MARK: - @IBAction
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        delegate?.updatePhoto(self.filterImageView.image ?? UIImage())
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let newImage = resizeImage(filterImage ?? UIImage(), 150)
        let ciImage = CIImage(image: newImage)
        let filter = CIFilter(name: allFilters[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            if let result = context.createCGImage(filteredImage, from: filteredImage.extent) {
                cell.filterPhotoImageView.image = UIImage(cgImage: result)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = CIImage(image: filterImage ?? UIImage())
        let filter = CIFilter(name: allFilters[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            if let result = context.createCGImage(filteredImage, from: filteredImage.extent) {
                filterImageView.image = UIImage(cgImage: result, scale: self.filterImageView.image!.scale, orientation: self.filterImageView.image!.imageOrientation)
            }
        }
    }
}

extension FilterViewController {
    //MARK: - Resize Image
    private func resizeImage(_ image: UIImage,_ newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
