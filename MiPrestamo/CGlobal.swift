//
//  CGlobal.swift
//  Mi Calculadora de Prestamo
//
//  Created by Américo Cantillo on 1/11/16.
//  Copyright © 2016 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation

// Class for Global Values

public class CGlobal {
    
    struct sGlobalData {
        static var planPrueba: CPlanPago?
    }
    
    let sectionKey: String = "Cuota"
    
    let identifierMyFinanceControllerLite = "1148364865"
    let identifierMiCalculadoraDePrestamos = "1124516490"
    let titlesDetail: [String] = ["Valor de la cuota", "Total pagado antes de la cuota", "Abono a capital", "Abono a interés", "Saldo pendiente después de la cuota", "Total pagado después de la cuota"]
    //dCuota["Cuota"] = Double(pathIndex.row + 1)
    //dCuota["Valor de la cuota"] = douCuota.doubleValue
    //dCuota["Total pagado antes de la cuota"] = douPaid.doubleValue
    //dCuota["Abono a capital"] = douCapital.doubleValue
    //dCuota["Abono a interés"] = douInteres.doubleValue
    //dCuota["Saldo pendiente después de la cuota"] = douSaldo.doubleValue
    //dCuota["Total pagado después de la cuota"] =  douPagado.doubleValue

    func getPath(_ fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
}
