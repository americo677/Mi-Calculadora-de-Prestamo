//
//  TVCDetailCuota.swift
//  Mi Calculadora de Prestamo
//
//  Created by Américo Cantillo on 30/10/16.
//  Copyright © 2016 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class VCDetailCuota: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dDetail = [String: Double]()
    let formatterMon : NumberFormatter = NumberFormatter()
    let formatterInt : NumberFormatter = NumberFormatter()
    
    @IBOutlet weak var tvDetail: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        initFormatters()
        
        
        
        self.tvDetail.dataSource = self
        self.tvDetail.delegate = self
        
        self.view = self.tvDetail
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initFormatters() {
        formatterMon.numberStyle = .currencyAccounting
        formatterMon.maximumFractionDigits = 2
        
        formatterInt.numberStyle = .decimal
        formatterInt.maximumFractionDigits = 0
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (CGlobal().sectionKey + " No. " + formatterInt.string(from: NSNumber.init(value: dDetail[CGlobal().sectionKey]!))!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dDetail.count - 1
    }
    
    // MARK: - Celda personalizada
    func customTableView(ctableView: UITableView, cindexPath: NSIndexPath, dictionary: Dictionary<String, Double>, caccessoryType: UITableViewCellAccessoryType) -> UITableViewCell {
        
        let cell = ctableView.dequeueReusableCell(withIdentifier: "customCell", for: cindexPath as IndexPath)
        
        // Para evitar el re-writting de los labels personalizados
        for cellView in cell.contentView.subviews {
            cellView.removeFromSuperview()
        }
        
        //let labelTitle     : UILabel = UILabel(frame: CGRectMake(0.0, 0.0, 377.0, 35.0))
        //let labelTitle     : UILabel = UILabel(frame: CGRectMake(0.0, 0.0, 339.0, 35.0))
        let labelTitle     : UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 35.0))
        
        //339.00
        
        labelTitle.lineBreakMode = .byTruncatingTail
        
        labelTitle.numberOfLines = 2
        
        let labelValue    : UILabel = UILabel(frame: CGRect(x:100.0, y:20.0, width:150.0, height:25.0))
        
        let fontName =  "Verdana-Bold"
        let fontNameNumeric = "Verdana"
        
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        
        labelTitle.text = CGlobal().titlesDetail[cindexPath.row]
        labelValue.text = formatterMon.string(from: NSNumber.init(value: dictionary[CGlobal().titlesDetail[cindexPath.row]]!))
        
        labelTitle.font = UIFont(name: fontName, size: 12)
        labelTitle.textColor = UIColor.gray
        labelTitle.tag = cindexPath.row
        //labelTitle.backgroundColor = UIColor
        labelTitle.textAlignment = .left
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(labelTitle)
        
        let labelTitleLeadingConstraint = NSLayoutConstraint(item: labelTitle, attribute:NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.leftMargin, multiplier: 1, constant: 10)
        
        let labelTitleWidthConstraint = NSLayoutConstraint(item: labelTitle, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: cell.contentView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        
        let labelTitleTopConstraint = NSLayoutConstraint(item: labelTitle, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: 1)

        cell.addConstraint(labelTitleLeadingConstraint)
        cell.addConstraint(labelTitleWidthConstraint)
        cell.addConstraint(labelTitleTopConstraint)
        
        
        labelValue.font = UIFont(name: fontNameNumeric, size: 13)
        labelValue.textColor = UIColor.gray
        labelValue.tag = cindexPath.row
        labelValue.textAlignment = .right
        //labelValue.backgroundColor = UIColor.gray
        
        labelValue.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(labelValue)
        
        //let newView = UIView()
        //newView.backgroundColor = UIColor.red
        //newView.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(newView)
        
        //let horizontalConstraint = NSLayoutConstraint(item: labelValue, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        //do {
            let labelValueTrailingConstraint = NSLayoutConstraint(item: labelValue, attribute:NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -10)

        
        let labelValueVerticalConstraint = NSLayoutConstraint(item: labelValue, attribute:NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: 1)
        //} catch {
        //    let err = error as NSError
        //    print("\(err.localizedDescription)")
        //}

        
   //     let trailingConstraint = NSLayoutConstraint(item: labelValue, attribute:NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.rightMargin, multiplier: 1, constant: 20)
        
        //let verticalConstraint = NSLayoutConstraint(item: labelValue, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        //let widthConstraint = NSLayoutConstraint(item: labelValue, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        //let heightConstraint = NSLayoutConstraint(item: labelValue, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        
        //view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        cell.contentView.addConstraint(labelValueTrailingConstraint)
        cell.contentView.addConstraint(labelValueVerticalConstraint)

        
        
        
        
        
        
        
        //cell.accessoryType = caccessoryType
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        
        var cell: UITableViewCell?
        
        // Configure the cell...
        
        cell = customTableView(ctableView: tableView, cindexPath: indexPath as NSIndexPath, dictionary: dDetail, caccessoryType: .none)
        
        return cell!
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
