//
//  ViewController.swift
//  CameraFilter
//
//  Created by Mohammad Azam on 2/13/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let photosCollectionViewController = navigationController.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("Segue destination not found")
        }
        
        photosCollectionViewController.selectedPhoto.subscribe { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }
        .disposed(by: disposeBag)
    }
    
    @IBAction func applyFilterButtonWasPressed() {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { [weak self] filteredImage in
                DispatchQueue.main.async {
                    self?.photoImageView.image = filteredImage
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.filterButton.isHidden = false
    }
}

