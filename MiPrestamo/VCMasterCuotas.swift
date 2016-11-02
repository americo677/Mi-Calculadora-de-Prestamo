//
//  VCMasterCuotas.swift
//  MiCalculadoraPrestamo
//
//  Created by Américo Cantillo on 24/05/16.
//  Copyright © 2016 Américo Cantillo. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class VCMasterCuotas: UIViewController, MFMailComposeViewControllerDelegate {
        
    
    var cppPlan   : PlanPago?
    let formatter : NumberFormatter = NumberFormatter()
    //let moc       : NSManagedObjectContext = NSManagedObjectContext()  
    let moc = DataController().managedObjectContext
    let strAppTitle = "Mi Calculadora de Préstamo"
    var dCuota = [String: Double]()
    
    @IBOutlet var tvCuotas: UITableView!

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            mail.setMessageBody("<p>Here is your Budget</p>", isHTML: true)
            
            
            #if LITE_VERSION
                mail.setSubject(strAppTitle + " Lite demo sending")
            #endif
            
            #if FULL_VERSION
                mail.setSubject(strAppTitle + ": " + (self.presupuesto?.descripcion)!)
            #endif
            
            let csvString = "String for testing"
                
                //self.writeCoreDataObjectToCVS(self.presupuesto?.secciones?.allObjects as! [NSManagedObject] ,named: "no_name")
            
            let data = csvString.data(using: String.Encoding.utf8)
            
            let strExportFileName = "TheFileName"
                
                //self.presupuesto?.descripcion?.stringByReplacingOccurrencesOfString(" ", withString: "_")
            
            mail.addAttachmentData(data!, mimeType: "text/csv", fileName: "\(strExportFileName).csv")
            
            self.present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            //showCustomWarningAlert("You must authorize sending e-mail.", toFocus: nil)
        }
    }

    func btnActionOnTouchInsideUp(sender: AnyObject) {
        
        let alertController = UIAlertController(title: self.strAppTitle, message: "Enviar el plan de pagos", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            print(action)
        }

        let oneAction = UIAlertAction(title: "Enviar E-mail", style: .default) { (_) in
            self.sendEmail()
        }
        
        alertController.addAction(oneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
        }
        
    }

    func loadPreferences() {
        let backButton = UIBarButtonItem(title: "Proyección", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        
        // Bar title text color
        //let shadow = NSShadow()
        //shadow.shadowColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //shadow.shadowOffset = CGSize(0, 1)
        
        let color = UIColor.customLightYellow()
        
        let titleFont : UIFont = UIFont(name: "Futura", size: 14)!
        
        let attributes = [
            NSForegroundColorAttributeName : color,
            //NSShadowAttributeName : shadow,
            NSFontAttributeName : titleFont
        ]
        
        
        backButton.setTitleTextAttributes(attributes, for: UIControlState.normal)
        
        self.navigationItem.backBarButtonItem = backButton
        
        self.tvCuotas.tintColor = UIColor.customLightGreen()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        self.loadPreferences()
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        fetchPlan()
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        var items = [AnyObject]()
        
        items.append(UIBarButtonItem(title: "Enviar", style: .plain, target: self,action: #selector(self.btnActionOnTouchInsideUp)))
        
        self.toolbarItems = items as? [UIBarButtonItem]

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        
        
    }
    
    func fetchPlan() {
        
        if cppPlan?.douPrestamo == 0 {
            // Swift 2.3
            // let planf: NSFetchRequest = NSFetchRequest(entityName: "CPlanPago")
            // Swift 3.0
            let planf: NSFetchRequest<NSFetchRequestResult> = CPlanPago.fetchRequest()
            do {
                // Swift 2.3
                // let plan = try moc.fetch(planf) as! [CPlanPago]
                // Swift 3.0
                let plan = try moc.fetch(planf) as! [CPlanPago]
                
                if !plan.isEmpty {
                    cppPlan?.douPrestamo = plan.first!.douPrestamo!.doubleValue
                    cppPlan?.douTasa = plan.first!.douTasa!.doubleValue
                    cppPlan?.douTiempo = plan.first!.douTiempo!.doubleValue
                    cppPlan?.arrCuotas = plan.first!.arrCuotas! as! [Double]
                    cppPlan?.arrInteres = plan.first!.arrInteres! as! [Double]
                    cppPlan?.arrCapital = plan.first!.arrCapital! as! [Double]
                    cppPlan?.arrSaldo   = plan.first!.arrSaldo! as! [Double]
                    cppPlan?.arrPagado  = plan.first!.arrPagado! as! [Double]
                    cppPlan?.douTotalPagado = plan.first!.douTotalPagado!.doubleValue
                } else {
                    print("En cuotas no hay plan previamente almacenado.")
                }
            } catch {
                fatalError("No se pudo recuperar los datos almacenados: \(error)")
            }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cppPlan?.douPrestamo == 0 {
            return 0
        }
        
        return cppPlan!.arrCuotas.count
    }

    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath pathIndex: IndexPath) -> UITableViewCell {
        
        DispatchQueue.main.async(execute: {})
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: pathIndex)
        
        // Para evitar el re-writting de los labels personalizados
        for cellView in cell.contentView.subviews {
            cellView.removeFromSuperview()
        }

        let strTitulo: String = String(format:"Cuota No. %2i    ", (pathIndex as NSIndexPath).row + 1)
        
        let strMensaje: String = String(format:"Valor de la Cuota : \(formatter.string(from: (cppPlan!.arrCuotas[pathIndex.row] as NSNumber))!)")
        
        let fontName = cell.textLabel!.font.fontName
        
        cell.textLabel?.font = UIFont(name: fontName , size: 12)
        cell.textLabel?.textColor = UIColor.blue
        cell.textLabel?.text = strTitulo

        cell.detailTextLabel?.font = UIFont(name: fontName, size: 15)
        cell.detailTextLabel?.textColor = UIColor.darkGray
        cell.detailTextLabel?.text = strMensaje
        
        cell.accessoryType = .detailButton

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath pathIndex: IndexPath) {
        // Swift 2.3
        //let strMensaje: String = String(format:"Cuota No. %2i\nHas pagado          : %@\nValor de la Cuota   : %@\nAbonas a capital    : %@\nPagas en intereses  : %@\nDeuda pendiente     : %@", (pathIndex as NSIndexPath).row + 1, formatter.string(from: cppPlan!.arrPagado[(pathIndex as NSIndexPath).row] - cppPlan!.arrCuotas[(pathIndex as NSIndexPath).row])!, formatter.string(from: cppPlan!.arrCuotas[(pathIndex as NSIndexPath).row])! , formatter.string(from: cppPlan!.arrCapital[(pathIndex as NSIndexPath).row])!, formatter.string(from: cppPlan!.arrInteres[(pathIndex as NSIndexPath).row])!, formatter.string(from: cppPlan!.arrSaldo[(pathIndex as NSIndexPath).row])!)
        
        // Swift 3.0
        let douPagado: NSNumber  = cppPlan!.arrPagado[pathIndex.row] as NSNumber
        let douCuota: NSNumber   = cppPlan!.arrCuotas[pathIndex.row] as NSNumber
        let douCapital: NSNumber = cppPlan!.arrCapital[pathIndex.row] as NSNumber
        let douInteres: NSNumber = cppPlan!.arrInteres[pathIndex.row] as NSNumber
        let douSaldo: NSNumber   = cppPlan!.arrSaldo[pathIndex.row] as NSNumber
        let douPaid: NSNumber    = ((douPagado as Double) - (douCuota as Double)) as NSNumber
        
        
        //dCuota["Cuota"] = Double(pathIndex.row + 1)
        
        dCuota[CGlobal().sectionKey] = Double(pathIndex.row + 1)
        
        //dCuota["Valor de la cuota"] = douCuota.doubleValue
        dCuota[CGlobal().titlesDetail[0]] = douCuota.doubleValue
        
        
        //dCuota["Total pagado antes de la cuota"] = douPaid.doubleValue
        dCuota[CGlobal().titlesDetail[1]] = douPaid.doubleValue
        
        //dCuota["Abono a capital"] = douCapital.doubleValue
        dCuota[CGlobal().titlesDetail[2]] = douCapital.doubleValue
        
        //dCuota["Abono a interés"] = douInteres.doubleValue
        dCuota[CGlobal().titlesDetail[3]] = douInteres.doubleValue
        
        //dCuota["Deuda pendiente después de la cuota"] = douSaldo.doubleValue
        dCuota[CGlobal().titlesDetail[4]] = douSaldo.doubleValue
        
        //dCuota["Total pagado después de la cuota"] =  douPagado.doubleValue
        dCuota[CGlobal().titlesDetail[5]] = douPagado.doubleValue
        
        
        //let strMensaje = String(format: "Cuota \(pathIndex.row + 1)\nHas pagado          : \(formatter.string(from: douPaid)!)\nValor de la Cuota   : \(formatter.string(from: douCuota)!)\nAbonas a capital    : \(formatter.string(from: douCapital)!)\nPagas en intereses  : \(formatter.string(from: douInteres)!)\nDeuda pendiente     : \(formatter.string(from:douSaldo)!)")
        
        
        //let alertController = UIAlertController(title: "Detalle de la cuota", message: strMensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        //alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default,handler: nil))
        
        //self.present(alertController, animated: true, completion: nil)

        //print(strMensaje)
        
        self.performSegue(withIdentifier: "segueDetail", sender: self)
        
        //let vcDetail = storyboard?.instantiateViewController(withIdentifier: "VCDetailCuota")
        
        //storyboard.ins
        //present(vcDetail!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueDetail" {
            let vcDet = segue.destination as! VCDetailCuota 
            vcDet.dDetail = [:]
            vcDet.dDetail = self.dCuota
        }
    }
}
