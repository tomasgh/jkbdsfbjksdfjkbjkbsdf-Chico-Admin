//
//  PageViewSwiftUI.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 4/4/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import SwiftUI

struct PageViewSwiftUI: View {
    
    var body: some View {
        EmptyView()
    }
}

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[0]], direction: .forward, animated: true)
    }
}

struct PageViewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        PageViewSwiftUI()
    }
}
