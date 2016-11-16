//
//  VCWebView.swift
//  Mi Calculadora de Préstamo
//
//  Created by Américo Cantillo on 15/06/16.
//  Copyright © 2016 Américo Cantillo. All rights reserved.
//

import UIKit

class VCWebView: UIViewController, UIWebViewDelegate {

    @IBOutlet var wvWebView: UIWebView!
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    // MARK: - Carga inicial de vista
    
    func loadPreferences() {
        
        // Cambia el color de la navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.customLightGreen()
        
        // Cambia el color del texto de la navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.customLightYellow(),  NSFontAttributeName: UIFont(name: "Futura", size: 16)!]
        
        self.navigationController?.navigationBar.tintColor = UIColor.customLightYellow()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let testHTML = NSBundle.mainBundle().pathForResource("docmicalculadora", ofType: "html")
        
        if self.revealViewController() != nil {
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        loadPreferences()
        
        let testHTML = Bundle.main.url(forResource: "docmicalculadora", withExtension: "html")
        //var contents = NSString(contentsOfFile: testHTML!, encoding: NSUTF8StringEncoding, error: nil)
        //let baseUrl = NSURL(fileURLWithPath: testHTML!) //for load css file
        
        print("html: \(testHTML!)")
        //print("baseURl: \(baseUrl)")
        
        let request = URLRequest(url: testHTML!)
        
        wvWebView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
