//
//  DataSetValueFormatter.swift
//  super_heroes
//
//  Created by Manuel Alejandro Verdugo Pérez on 07/06/20.
//  Copyright © 2020 Manuel Alejandro Verdugo Pérez. All rights reserved.
//

import Foundation
import Charts

class DataSetValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        ""
    }
}

class XAxisFormatter: IAxisValueFormatter {
    let titles = ["intelligence",  "strength",  "speed", "durability", "power", "combat"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        titles[Int(value) % titles.count]
    }
}
