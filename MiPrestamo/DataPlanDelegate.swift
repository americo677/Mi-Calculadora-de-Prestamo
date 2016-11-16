//
//  DataPlanDelegate.swift
//  Mi Calculadora de Prestamo
//
//  Created by Américo Cantillo on 14/11/16.
//  Copyright © 2016 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import CoreData

@objc protocol DataPlanDelegate: class {
    @objc optional func sendDataPlan(_ planPago: [CPlanPago]?)
    @objc optional func sendDataManagedObjectContext(_ moc: NSManagedObjectContext?)
}
