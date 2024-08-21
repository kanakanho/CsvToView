//
//  CsvDataHandler.swift
//  CsvToView
//
//  Created by blue ken on 2024/08/20.
//

import Foundation
import TabularData

public class CsvDataHandler {
    private var filePath: String
    private var dataFrame: DataFrame = DataFrame()

    init(filepath:String) {
        self.filePath = filepath
        readCsv()
        addEndTimeColumn()
        printDataFrameContents()
    }

    func readCsv() {
        guard let path = Bundle.main.url(forResource: filePath, withExtension: "csv") else {
            print("csvファイルがないよ")
            return
        }

        do {
            dataFrame = try DataFrame(contentsOfCSVFile: path, columns: ["ID", "Onset Time", "Duration", "MIDI Note Number"])
        } catch {
            print("エラー: \(error)")
            return
        }
    }

    func addEndTimeColumn() {
        let onsetTimeColumn = dataFrame["Onset Time",Double.self]
        let durationColumn = dataFrame["Duration",Double.self]
        let endTimeColumn = onsetTimeColumn + durationColumn
        dataFrame.append(column: Column(name: "End Time", contents: endTimeColumn))
    }

    func printDataFrameContents() {
        print(dataFrame)
    }

    public func getDataFrame() -> DataFrame {
        return self.dataFrame
    }
}

