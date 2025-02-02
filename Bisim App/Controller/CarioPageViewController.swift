//
//  CarioPageViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CarioPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageImages: [String] = ["mobile_sign","intro_slide_2","intro_slide_3","intro_slide_4"]
    var pageSubjects: [String] = ["","","",""]
    var pageDetails: [String] = ["برای استفاده از بیسیم اپ با شماره همراه خود ثبت نام کنید.","در بیسیم اپ فقط کافی است مبدا و مقصد خود را روی نقشه انتخاب کنید و درخواست تاکسی دهید. به همین سادگی!","با بیسیم اپ ارزان تر جا به جا شوید بهمراه تخفیفات دوره ای و سرویس اختصاصی برای بانوان.","کانال و اینستاگرام ما را دنبال کنید و از آخرین اخبار، تخفیفات و آموزش ها با خبر شوید."]

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    

    // Method
    func updateUI() {
        dataSource = self
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CarioContentPageViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CarioContentPageViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> CarioContentPageViewController? {
        if index < 0 || index >= 4 {
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: CARIO_CONTENT_PAGE_VIEW_CONTROLLER_ID) as? CarioContentPageViewController {
            pageContentViewController.index = index
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.subject = pageSubjects[index]
            pageContentViewController.detail = pageDetails[index]
            return pageContentViewController
        }
        return nil
    }
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    static func showModal() -> CarioPageViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let carioPageViewController = storyBoard.instantiateViewController(withIdentifier: CARIO_PAGE_VIEW_VIEW_CONTROLLER_ID) as! CarioPageViewController
        return carioPageViewController
    }
    

}
