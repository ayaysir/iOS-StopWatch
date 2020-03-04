//
//  HistoryViewController.swift
//  StopWatch
//
//  Created by yoonbumtae on 2020/02/28.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

var historyArr = [Dictionary<String, String>]()

class HistoryViewController: UIViewController {

    @IBOutlet var tblDataList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tblDataList.dataSource = self
        tblDataList.delegate = self
        
        scrollToBottom()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyFileReader()
        tblDataList.reloadData()
        
    }
    
    func historyFileReader(){
        
        historyArr = [Dictionary<String, String>]()
        
        let file = "history.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            
            let isFileExist: Bool = FileManager.default.fileExists(atPath: fileURL.path)
            
            do {
                if !isFileExist {
                    print("no file")
                } else {
                    let str = try String(contentsOf: fileURL, encoding: .utf8)
                    let arr =  str.components(separatedBy: "\n")
                    
                    print("=========\n", arr)
                    arr.forEach { row in
                        if(row != ""){
                            let seperated = row.components(separatedBy: ",")
                            let dic = ["title": seperated[0], "date": seperated[1]]
                            historyArr.append(dic)
                            print(dic)
                        }
                    }
                    print(historyArr)
                }
            } catch   {
                print(error)
            }
        }
    }
    
    func timestampToDateFormat(strTimestamp: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(strTimestamp)!)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEEE"
        return formatter.string(from: date as Date)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: historyArr.count - 1, section: 0)
            self.tblDataList.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
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

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eachCell", for: indexPath)
        cell.textLabel?.text = "\(historyArr[indexPath.row]["title"]!)"
        cell.detailTextLabel?.text = "\(timestampToDateFormat(strTimestamp: historyArr[indexPath.row]["date"]!))"
        
        return cell
    }
    
}
