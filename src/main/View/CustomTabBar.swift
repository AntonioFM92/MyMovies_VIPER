//
//  CustomTabBar.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 23/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpImagaOntabbar([UIImage(named: "movies-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "favs")!.withRenderingMode(.alwaysOriginal), UIImage(named: "recommended-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "info")!.withRenderingMode(.alwaysOriginal)], [UIImage(named: "movies_unsel-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "favs_unselected")!.withRenderingMode(.alwaysOriginal), UIImage(named: "recommended_unsel-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "info_unsel")!.withRenderingMode(.alwaysOriginal)], nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.setUpImagaOntabbar([UIImage(named: "movies-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "favs")!.withRenderingMode(.alwaysOriginal), UIImage(named: "recommended-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "info")!.withRenderingMode(.alwaysOriginal)], [UIImage(named: "movies_unsel-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "favs_unselected")!.withRenderingMode(.alwaysOriginal), UIImage(named: "recommended_unsel-icon")!.withRenderingMode(.alwaysOriginal), UIImage(named: "info_unsel")!.withRenderingMode(.alwaysOriginal)], nil)
    }

}

extension UITabBarController {
    func setUpImagaOntabbar(_ selectedImage : [UIImage], _ image : [UIImage], _ title : [String]?){
        
        guard let tabBarItems = self.tabBar.items else {
            return
        }
        print(image.enumerated())
        print(tabBarItems.enumerated())
        for (index, _) in tabBarItems.enumerated() {
            tabBarItems[index].image = image[index]
            tabBarItems[index].selectedImage = selectedImage[index]
                
            if let tabTitle = title?[index] {
                tabBarItems[index].title = tabTitle
            }
        }
    }
    
    func getSelectedTabIndex() -> Int? {
        if let selectedItem = self.tabBar.selectedItem {
            return self.tabBar.items?.firstIndex(of: selectedItem)
        }
        return nil
    }
}
