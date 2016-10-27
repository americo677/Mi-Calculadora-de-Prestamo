//
//  ViewController.swift
//  MiPrestamo
//
//  Created by Américo Cantillo on 22/05/16.
//  Copyright © 2016 Américo Cantillo. All rights reserved.
//

import UIKit

import CoreData

class VCMiPrestamoMain: UIViewController, UITextFieldDelegate {
    

    let preferencias = UserDefaults.standard

    @IBOutlet weak var txtMonto: UITextField!
    
    @IBOutlet weak var txtTiempo: UITextField!

    @IBOutlet weak var txtTasaEA: UITextField!
    
    @IBOutlet weak var txtTasa: UITextField!
    
    @IBOutlet weak var lblTotalAPagar: UILabel!
    
    var boolInvalido: Bool = false
    
    var cppPlan: PlanPago?
    
    let strEntidadPlan: String = "CPlanPago"
    
    let moc = DataController().managedObjectContext
    
    let douPeriodosxAno: Double = 12
    
    let formatter    : NumberFormatter = NumberFormatter()
    let formatterInt : NumberFormatter = NumberFormatter()
    let formatterFlt : NumberFormatter = NumberFormatter()
    
    var boolDatoObligatorio: [Bool] = [false, false, false]
    
    func loadPreferences() {
        if preferencias.double(forKey: "initMonto") != 0 {
            txtMonto.text = formatter.string(from: (preferencias.double(forKey: "initMonto") as NSNumber))
            //txtMonto.text = formatter.string(from: NSNumber(preferencias.double(forKey: "initMonto")))
        }
        
        if preferencias.integer(forKey: "initTiempo") != 0 {
            // txtTiempo.text = formatterInt.string(from: NSNumber(preferencias.integer(forKey: "initTiempo")))
            txtTiempo.text = formatterInt.string(from: (preferencias.integer(forKey: "initTiempo") as NSNumber))
        }
        
        if preferencias.double(forKey: "initTEA") != 0.0 {
            txtTasaEA.text = formatterFlt.string(from: (preferencias.double(forKey: "initTEA") as NSNumber))
        }
        
        if preferencias.double(forKey: "initTEM") != 0 {
            txtTasa.text = formatterFlt.string(from: (preferencias.double(forKey: "initTEM") as NSNumber))
        }
        
        if preferencias.double(forKey: "initDeudaTotal") != 0 {
            lblTotalAPagar.text = formatter.string(from: (preferencias.double(forKey: "initDeudaTotal") as NSNumber))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        cppPlan = PlanPago()
        
        loadPreferences()
        
        txtMonto.placeholder  = "Monto del préstamo"
        txtTasa.placeholder   = "% Tasa pactada"
        txtTiempo.placeholder = "Número de meses"
        txtTasaEA.placeholder = "% Tasa Efectiva Anual"
        
        txtMonto.delegate     = self
        txtTiempo.delegate    = self
        txtTasaEA.delegate    = self
        txtTasa.delegate      = self
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        formatterInt.numberStyle = .none
        
        formatterFlt.numberStyle = .decimal
        formatterFlt.maximumFractionDigits = 2
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VCMiPrestamoMain.dismissKeyboard))
        
        
        self.view.addGestureRecognizer(tap)
        
        fetchPlan()
        
    }
    
    @IBAction func txtMontoOnEditingDidEnd(_ sender: UITextField) {
        var monto: Double?
        
        if sender.hasText {
            boolDatoObligatorio[0] = validarValorNumericoMon(sender.text)
            if boolDatoObligatorio[0] == false {
                showCustomWarningAlert("Por favor verifique el valor del monto.  ¡No es válido!.", toFocus: sender)
            } else {
                print("Log: \(sender.text!) es un número válido!")
                //let monto: Double = formatter.numberFromString(sender.text!)!.doubleValue
                
                if formatterFlt.number(from: sender.text!)?.doubleValue == nil {
                    monto = formatter.number(from: sender.text!)?.doubleValue
                } else {
                    monto = formatterFlt.number(from: sender.text!)?.doubleValue
                }

                sender.text = formatter.string(from: (monto! as NSNumber))
            }
        }
    }
    
    @IBAction func txtTiempoOnEditingDidEnd(_ sender: UITextField) {
        
        if sender.hasText {
            boolDatoObligatorio[1] = validarValorNumericoDec(sender.text)

            if boolDatoObligatorio[1] == false {
                showCustomWarningAlert("Por favor verifique el valor del plazo.  ¡No es válido!.", toFocus: sender)
            } else {
                print("Log: \(sender.text!) es un número válido!")
                let tiempo: Int = formatterInt.number(from: sender.text!)!.intValue
                sender.text = formatterInt.string(from: (tiempo as NSNumber))
                
                preferencias.set(tiempo, forKey: "initTiempo")
            }
        }
    }
    
    @IBAction func txtTasaEAOnEditingDidEnd(_ sender: UITextField) {
        if sender.hasText {
            boolDatoObligatorio[2] = validarValorNumericoFlt(sender.text)
            if boolDatoObligatorio[2] == false {
                showCustomWarningAlert("Por favor verifique el valor de la tasa EA.  ¡No es válida!.", toFocus: sender)
            } else {
                print("Log: \(sender.text!) es un número válido!")
                let tasa: Double = formatterFlt.number(from: sender.text!)!.doubleValue
                preferencias.set(tasa, forKey: "initTEA")
                
                let tnominal = (pow(1+tasa/100,0.0833333333333333)-1)*12*100
                let mensual: Double  = tnominal/12
                
                sender.text = formatterFlt.string(from: (tasa as NSNumber))
                //txtTasa.text = formatterFlt.stringFromNumber(tasa / douPeriodosxAno)
                txtTasa.text = formatterFlt.string(from: (mensual as NSNumber))
                
                preferencias.set(mensual, forKey: "initTEM")

            }
        }
    }
    
    @IBAction func txtTasaOnEditingDidEnd(_ sender: UITextField) {
        if sender.hasText {
            boolDatoObligatorio[2] = validarValorNumericoFlt(sender.text)
            if boolDatoObligatorio[2]  == false {
                showCustomWarningAlert("Por favor verifique el valor de la tasa.  ¡No es válida!.", toFocus: sender)
            } else {
                print("Log: \(sender.text!) es un número válido!")
                let tasa: Double = formatterFlt.number(from: sender.text!)!.doubleValue
                sender.text = formatterFlt.string(from: (tasa as NSNumber))
                preferencias.set(tasa, forKey: "initTEM")

                
                let tea: Double = 100 * (pow(tasa/100 + 1, 12) - 1)
                //txtTasaEA.text = formatterFlt.stringFromNumber(tasa * douPeriodosxAno)
                txtTasaEA.text = formatterFlt.string(from: (tea as NSNumber))
                
                preferencias.set(tea, forKey: "initTEA")
            }
        }
    }
    
    func fetchPlan() {
        
        if cppPlan?.douPrestamo == 0 {
            // Swift 2.3
            //let planf = NSFetchRequest(entityName: "CPlanPago")
            
            // Swift 3.0
            let planf: NSFetchRequest<NSFetchRequestResult> = CPlanPago.fetchRequest()                
            do {
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
                    
                    txtMonto.text = String(format:"%@", formatter.string(from: (cppPlan!.douPrestamo as NSNumber))!)
                    boolDatoObligatorio[0] = true
                    txtTasa.text  = String(format:"%@", formatterFlt.string(from: (cppPlan!.douTasa * 100 as NSNumber))!)
                    boolDatoObligatorio[2] = true
                    //txtTasaEA.text = String(format:"%@", formatterFlt.stringFromNumber(cppPlan!.douTasa * 100 * douPeriodosxAno)!)
                    txtTasaEA.text = String(format:"%@", formatterFlt.string(from: (100 * (pow(cppPlan!.douTasa + 1, 12) - 1) as NSNumber))!)
                    
                    txtTiempo.text = String(format:"%@", formatterInt.string(from: (cppPlan!.douTiempo as NSNumber))!)
                    boolDatoObligatorio[1] = true
                    lblTotalAPagar.text = String(format:"%@", formatter.string(from: (cppPlan!.douTotalPagado as NSNumber))!)
                    
                    //preferencias.setDouble(cppPlan!.douTotalPagado, forKey: "initDeudaTotal")
                } else {
                    print("En la principal no hay plan previamente almacenado.")
                }
            } catch {
                fatalError("No se pudo recuperar los datos almacenados: \(error)")
            }
        }
        
    }

    func validarValorNumericoMon(_ txtValor: String?) -> Bool {
        
        var boolResultado: Bool = true
        
        var douValor: Double?

        if !(txtValor?.isEmpty)! {
            if formatterInt.number(from: txtValor!)?.doubleValue == nil {
                douValor = formatter.number(from: txtValor!)?.doubleValue
            } else {
                douValor = formatterInt.number(from: txtValor!)?.doubleValue
            }
            
            if douValor == nil {
                print("El valor del monto no es un número válido!")
                boolResultado = false
            }
        } else {
            print("El valor del monto está vacío!")
            boolResultado = false
        }
        return boolResultado
    }

    func validarValorNumericoDec(_ txtValor: String?) -> Bool {
        
        var boolResultado: Bool = true
        
        if !(txtValor?.isEmpty)! {
            let douValor = formatterInt.number(from: txtValor!)?.doubleValue
            
            if douValor == nil {
                print("El valor del plazo no es un número válido!")
                boolResultado = false
            }
        } else {
            print("El valor del plazo está vacío!")
            boolResultado = false
        }
        return boolResultado
    }
    
    func validarValorNumericoFlt(_ txtValor: String?) -> Bool {
        
        var boolResultado: Bool = true
        
        if !(txtValor?.isEmpty)! {
            let douValor = formatterFlt.number(from: txtValor!)?.doubleValue
            
            if douValor == nil {
                print("El valor de la tasa no es un número válido!")
                boolResultado = false
            }
        } else {
            print("El valor de la tasa está vacío!")
            boolResultado = false
        }
        return boolResultado
    }
    
    func showCustomWarningAlert(_ strMensaje: String, toFocus: UITextField) {
        let alertController = UIAlertController(title: "Mi Calculadora de Préstamos", message:
            strMensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
            toFocus.becomeFirstResponder()})
        
        alertController.addAction(action)
        
        //alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func btnCalcularTouchUpInside(_ sender: UIButton) {
        var dato: Int = 0
        
        var boolCalcular: Bool = true
        
        repeat {
            if boolDatoObligatorio[dato] == false {
                if dato == 0 {
                    showCustomWarningAlert("Por favor verifique el valor del monto.  ¡No es válido!.", toFocus: self.txtMonto)
                } else
                if dato == 1 {
                    showCustomWarningAlert("Por favor verifique el valor del plazo.  ¡No es válido!.", toFocus: self.txtTiempo)
                } else
                if dato == 2 {
                    showCustomWarningAlert("Por favor verifique el valor de la tasa.  ¡No es válida!.", toFocus: self.txtTasa)
                }
                boolCalcular = false
            }
            dato += 1
        } while dato < boolDatoObligatorio.count
        
        if boolCalcular {
            cppPlan! = PlanPago.init()
            calcularCuotas()
        }
    }
    
    func guardarPlan(_ plan: PlanPago) {

        // Swift 2.3
        //let planf = NSFetchRequest(entityName: strEntidadPlan)
        
        // Swift 3.0
        let planf: NSFetchRequest<NSFetchRequestResult> = CPlanPago.fetchRequest()
        
        do {
            var plan = try moc.fetch(planf) as! [CPlanPago]
            
            if !plan.isEmpty {
                do {
                    moc.delete(plan.first!)
                    
                    plan.remove(at: 0)
                    
                    try moc.save()
                    
                } catch let error as NSError {
                    print("No se pudo guardar los datos.  Error: \(error)")
                }
            } else {
                print("No hay plan previamente almacenado.")
            }
            

        } catch {
            fatalError("Failed to fetch CPlanPago: \(error)")
        }
        
        
        let nseEntidad = NSEntityDescription.insertNewObject(forEntityName: strEntidadPlan, into: moc)
        
        nseEntidad.setValue(plan.douPrestamo, forKey: "douPrestamo")
        nseEntidad.setValue(plan.douTasa, forKey: "douTasa")
        nseEntidad.setValue(plan.douTiempo, forKey: "douTiempo")
        nseEntidad.setValue(plan.arrCuotas, forKey: "arrCuotas")
        nseEntidad.setValue(plan.arrInteres, forKey: "arrInteres")
        nseEntidad.setValue(plan.arrCapital, forKey: "arrCapital")
        nseEntidad.setValue(plan.arrSaldo, forKey: "arrSaldo")
        nseEntidad.setValue(plan.arrPagado, forKey: "arrPagado")
        nseEntidad.setValue(plan.douTotalPagado, forKey: "douTotalPagado")
        
        
        do {
            
            try moc.save()
            
        } catch let error as NSError {
            print("No se pudo guardar los datos.  Error: \(error)")
        }
        
    }
    
    func calcularCuotas() {

        var douR           : Double = 0         // Valor de la cuota
        let douP           : Double = formatter.number(from: txtMonto.text!)!.doubleValue
        
        preferencias.set(douP, forKey: "initMonto")
        
        // 25000000  // Préstamo
        let doui           : Double = formatterFlt.number(from: txtTasa.text!)!.doubleValue / 100   // 0.78    // Tasa
        let doun           : Double = formatterInt.number(from: txtTiempo.text!)!.doubleValue       // 72      // Plazo
        var douInteres     : Double = 0         // Valor del interés
        var douCapital     : Double = 0         // Valor del capital
        var douSaldo       : Double = douP      // Saldo después de la cuota
        var n              : Double = 0         // var de iteraciones
        
        cppPlan!.douPrestamo = douP
        cppPlan!.douTiempo = doun
        cppPlan!.douTasa = doui
        
        douR = douSaldo * ((doui * pow(1 + doui, doun)) / (pow(1 + doui, doun) - 1))
        
        print("Valor del préstamo: $\(douP)")
        
        repeat {
            douInteres = douSaldo * doui
            
            douCapital = douR - douInteres
            
            douSaldo = douSaldo - douCapital
            
            cppPlan!.arrCuotas.insert(douR, at: Int(n))
            cppPlan!.arrInteres.append(douInteres)
            cppPlan!.arrCapital.append(douCapital)
            cppPlan!.arrSaldo.append(douSaldo)
            
            cppPlan!.douTotalPagado += cppPlan!.arrCuotas[Int(n)]
            
            cppPlan!.arrPagado.append(cppPlan!.douTotalPagado)
            
            //print("Cuota No. \(Int(n)+1) Valor Cuota \(cppPlan!.arrCuotas[Int(n)]) Interes \(cppPlan!.arrInteres[Int(n)]) Capital abonado \(cppPlan!.arrCapital[Int(n)]) Saldo \(cppPlan!.arrSaldo[Int(n)])")
            
            n += 1
            
            
        } while (n < doun)
        
        //print("Total pagado: \(cppPlan!.douTotalPagado)")
        
        self.lblTotalAPagar!.text = String(format:"%@", formatter.string(from: (cppPlan!.douTotalPagado as NSNumber))!)
        preferencias.set(cppPlan!.douTotalPagado, forKey: "initDeudaTotal")

        guardarPlan(cppPlan!)
        
        self.performSegue(withIdentifier: "segueMasterCuotas", sender: cppPlan)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "segueMasterCuotas" {
            let vcMasterCuotas: VCMasterCuotas = segue.destination as! VCMasterCuotas
            
            vcMasterCuotas.cppPlan = cppPlan!
        }
        
    }
    
    
    @IBAction func lblAnyOnDidEndOnExit(_ sender: UITextField) {
        
        self.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


