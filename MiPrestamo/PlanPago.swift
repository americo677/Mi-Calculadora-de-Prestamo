//
//  CPlanPago.swift
//  MiCalculadoraPrestamo
//
//  Created by Américo Cantillo on 24/05/16.
//  Copyright © 2016 Américo Cantillo. All rights reserved.
//

import UIKit

class PlanPago: NSObject {

    var douPrestamo    : Double = 0.0
    var douTasa        : Double = 0.0
    var douTiempo      : Double = 0.0

    var arrCuotas      : [Double] = [Double]()      // Arreglo de valor de la cuota
    var arrInteres     : [Double] = [Double]()      // Arreglo de intéreses corrientes
    var arrCapital     : [Double] = [Double]()      // Arreglo de valor a capital
    var arrSaldo       : [Double] = [Double]()      // Arreglo del saldo pendiente luego de la cuota
    var arrPagado      : [Double] = [Double]()      // Arreglo del saldo pagado
    
    var douTotalPagado : Double = 0.0

}
