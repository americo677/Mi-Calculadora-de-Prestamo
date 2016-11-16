//
//  VCStore.swift
//  Mi Calculadora de Prestamo
//
//  Created by Américo Cantillo on 15/11/16.
//  Copyright © 2016 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import StoreKit

class VCStore: UIViewController, SKStoreProductViewControllerDelegate {
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    func loadPreferences() {
        // Cambia el color de la navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.customLightGreen()
        
        // Cambia el color del texto de la navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.customLightYellow(),  NSFontAttributeName: UIFont(name: "Futura", size: 16)!]
        
        self.navigationController?.navigationBar.tintColor = UIColor.customLightYellow()

        let color = UIColor.customLightYellow()
        
        let titleFont : UIFont = UIFont(name: "Futura", size: 14)!
        
        let attributes = [
            NSForegroundColorAttributeName : color,
            //NSShadowAttributeName : shadow,
            NSFontAttributeName : titleFont
        ]
        
        btnMenu.setTitleTextAttributes(attributes, for: UIControlState.normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPreferences()
        
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        openStoreProductWithiTunesItemIdentifier(identifier: CGlobal().identifierMyFinanceControllerLite)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                //self?.presentViewController(storeViewController, animated: true, completion: nil)
                self?.present(storeViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        //viewController.dismissViewControllerAnimated(true, completion: nil)
        
        viewController.dismiss(animated: true, completion: nil)
        
        // get instance from view controller from Storyboard ID
        let switchViewController = self.storyboard?.instantiateViewController(withIdentifier: "VCMiPrestamoMain") as! VCMiPrestamoMain
        
        self.navigationController?.pushViewController(switchViewController, animated: true)
        
        // 1. Get navigation controller
        //let navController = UINavigationController(rootViewController: switchViewController)
        
        // 2. Present the navigation controller
        
        //self.present(navController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
