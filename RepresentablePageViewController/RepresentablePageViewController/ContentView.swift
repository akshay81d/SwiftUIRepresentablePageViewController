//
//  ContentView.swift
//  RepresentablePageViewController
//
//  Created by Akshay Dochania on 02/07/20.
//  Copyright © 2020 app-developerz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(["1","2","3"])
    }
}

struct ContainerView: View {
    var controllers: [UIHostingController<TitlePage>]
    
    init(_ titles: [String]) {
        self.controllers = titles.map { UIHostingController(rootView: TitlePage(title: $0))
        }
    }
    var body: some View {
        PageViewController(controllers: self.controllers)
    }
}

struct TitlePage: View {
    var title: String
    
    var body: some View {
        Text(title)
    }
}

struct PageViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIPageViewController
    var controllers: [UIViewController]
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PageViewController>) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: UIViewControllerRepresentableContext<PageViewController>) {
        uiViewController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return self.parent.controllers.last
            }
            return self.parent.controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == self.parent.controllers.count - 1 {
                return self.parent.controllers.first
            }
            return self.parent.controllers[index + 1]
        }
        
        var parent: PageViewController
        
        init(_ parent: PageViewController) {
            self.parent = parent
        }
    }
}
