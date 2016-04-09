//
//  ViewController.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/27/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    struct HomeConstants{
        static let MenSegue = "Men Segue"
        static let WomenSegue = "Women Segue"
        static let CountryKey = "UserCountry"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCountry()
    }
    
    
    func configureCountry(){

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let locale = NSLocale.currentLocale()
        let country = locale.objectForKey(NSLocaleCountryCode) as? String
        let savedCountry = userDefaults.objectForKey(HomeConstants.CountryKey) as? String
        if savedCountry == nil{
            //No saved country so save it
            userDefaults.setValue(country, forKey: HomeConstants.CountryKey)
        }else if savedCountry != country{
            //It isn't the same so update the country
            userDefaults.setValue(country, forKey: HomeConstants.CountryKey)
        }
        print("The country code you found was \(country)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == HomeConstants.MenSegue{
            if let dvc = segue.destinationViewController.contentViewController as? DayViewController{
                dvc.gender = 2
            }
        }else if segue.identifier == HomeConstants.WomenSegue{
            if let dvc = segue.destinationViewController.contentViewController as? DayViewController{
                dvc.gender = 1
            }
        }
    }

}

extension UIViewController{
    var contentViewController: UIViewController{
        if let navCon = self as? UINavigationController{
            return navCon.visibleViewController!
        }else{
            return self
        }
    }
}

