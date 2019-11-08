//
//  ChartsViewController.swift
//  inabaApp4
//
//  Created by 深瀬貴将 on 2019/09/05.
//  Copyright © 2019 fukase. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var rect = view.bounds
        rect.origin.y += 20
        rect.size.height -= 20
        let chartView = HorizontalBarChartView(frame: rect)
        let entry = [
            BarChartDataEntry(x: 1, y: 30),
            BarChartDataEntry(x: 2, y: 20),
            BarChartDataEntry(x: 3, y: 40),
            BarChartDataEntry(x: 4, y: 10),
            BarChartDataEntry(x: 5, y: 30)
        ]
        let set = BarChartDataSet(entries: entry, label: "Data")
        chartView.data = BarChartData(dataSet: set)
        view.addSubview(chartView)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
