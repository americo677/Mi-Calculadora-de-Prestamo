//
//  CPlanPago+CoreDataProperties.swift
//  MiCalculadoraPrestamo
//
//  Created by Américo Cantillo on 30/05/16.
//  Copyright © 2016 Américo Cantillo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CPlanPago {

    @NSManaged var douPrestamo: NSNumber?
    @NSManaged var douTasa: NSNumber?
    @NSManaged var douTiempo: NSNumber?
    @NSManaged var arrCuotas: NSObject?
    @NSManaged var arrInteres: NSObject?
    @NSManaged var arrCapital: NSObject?
    @NSManaged var arrSaldo: NSObject?
    @NSManaged var arrPagado: NSObject?
    @NSManaged var douTotalPagado: NSNumber?

}
