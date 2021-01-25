//
//  ScheduleViewController.swift
//  Anime Search
//
//  Created by 林祐辰 on 2021/1/21.
//

import UIKit
import Network


class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var clientside :GetDatasFromJikan = AnimeDataFromJikan.shared
    var downloadTask:URLSessionDataTask?

    let connectionMonitor = NWPathMonitor()
    @IBOutlet weak var daySegment: UISegmentedControl!
    @IBOutlet weak var ScheduleView: UITableView!
    var genre = "schedule"
    var weekDay = "sunday"
    
    var sundayProgram = [SundayProgram]()
    var mondayProgram = [MondayProgram]()
    var tuesdayProgram = [TuesdayProgram]()
    var wednesdayProgram = [WednesdayProgram]()
    var thursdayProgram = [ThursdayProgram]()
    var fridayProgram = [FridayProgram]()
    var saturdayProgram = [SaturdayProgram]()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        connectionMonitor.pathUpdateHandler = { path in
             if path.status == .satisfied {
                self.getSundayProgram()
             } else if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    self.ifNoConnection()
                }
             }
          }
        connectionMonitor.start(queue: DispatchQueue.global())
        ScheduleView.delegate = self
        ScheduleView.dataSource =  self
    }
    
    func getSundayProgram(){
        weekDay = "sunday"
        downloadTask = clientside.getScheduleData(genre:genre,weekDay: weekDay, completion: { (acgProgram, error) in
            if let programs = acgProgram{
                self.sundayProgram = programs.sunday ?? []
            }
            
            DispatchQueue.main.async {
                self.ScheduleView.reloadData()
            }
        })
    }
    
    
    func getMondayProgram(){
        weekDay = "monday"
        downloadTask = clientside.getScheduleData(genre:genre,weekDay: weekDay, completion: { (acgProgram, error) in
            if let programs = acgProgram{
                self.mondayProgram = programs.monday ?? []
            }
            
            DispatchQueue.main.async {
                self.ScheduleView.reloadData()
            }
        })
    }
    
    func getTuesdayProgram(){
        weekDay = "tuesday"
        downloadTask = clientside.getScheduleData(genre:genre,weekDay: weekDay, completion: { (acgProgram, error) in
            if let programs = acgProgram{
                self.tuesdayProgram = programs.tuesday ?? []
            }
            
            DispatchQueue.main.async {
                self.ScheduleView.reloadData()
            }
        })
    }
    
    func getWednesdayProgram(){
        weekDay = "wednesday"
        downloadTask = clientside.getScheduleData(genre:genre,weekDay: weekDay, completion: { (acgProgram, error) in
            if let programs = acgProgram{
                self.wednesdayProgram = programs.wednesday ?? []
            }
            
            DispatchQueue.main.async {
                self.ScheduleView.reloadData()
            }
        })
    }
    
    func getThursdayProgram(){
        weekDay = "thursday"
        downloadTask = clientside.getScheduleData(genre:genre,weekDay: weekDay, completion: { (acgProgram, error) in
            self.downloadTask = nil
            if let programs = acgProgram{
                self.thursdayProgram = programs.thursday ?? []
            }
            
            DispatchQueue.main.async {
                self.ScheduleView.reloadData()
            }
        })
    }
    
    func getFridayProgram(){
        weekDay = "friday"
        downloadTask = clientside.getScheduleData(genre:genre,weekDay: weekDay, completion: { (acgProgram, error) in
            if let programs = acgProgram{
                self.fridayProgram = programs.friday ?? []

            }
            
            DispatchQueue.main.async {
                self.ScheduleView.reloadData()
            }
        })
    }
    
    func getSaturdayProgram(){
        weekDay = "saturday"
        downloadTask = clientside.getScheduleData(genre:genre,weekDay: weekDay, completion: { (acgProgram, error) in
            if let programs = acgProgram{
                self.saturdayProgram = programs.saturday ?? []

            }
            
            DispatchQueue.main.async {
                self.ScheduleView.reloadData()
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        switch daySegment.selectedSegmentIndex {
                case 0:
                    return sundayProgram.count
                case 1:
                    return mondayProgram.count
                case 2:
                    return tuesdayProgram.count
                case 3:
                    return wednesdayProgram.count
                case 4:
                    return thursdayProgram.count
                case 5:
                    return fridayProgram.count
                case 6:
                     return saturdayProgram.count
                default:
                     return sundayProgram.count
        }
        
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ScheduleView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as? ScheduleTableViewCell
        
         var sundayShow : SundayProgram
         var mondayShow :MondayProgram
         var tuesdayShow:TuesdayProgram
         var wednesdayShow : WednesdayProgram
         var thursdayShow:ThursdayProgram
         var fridayShow:FridayProgram
         var saturdayShow:SaturdayProgram
        
        let number = indexPath.row

        if daySegment.selectedSegmentIndex == 0{
            sundayShow = sundayProgram[number]
            cell?.programName.text = sundayShow.title
            
            if let url = URL(string: sundayShow.imageUrl){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.programImage.image = UIImage(data: data!)
                    }
                }.resume()
            }
            
        }else if daySegment.selectedSegmentIndex == 1{
            mondayShow = mondayProgram[number]
            cell?.programName.text = mondayShow.title
            
            if let url = URL(string: mondayShow.imageUrl){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.programImage.image = UIImage(data: data!)
                    }
                }.resume()
            }
        }else if daySegment.selectedSegmentIndex == 2{
            tuesdayShow = tuesdayProgram[number]
            cell?.programName.text = tuesdayShow.title
            
            if let url = URL(string: tuesdayShow.imageUrl){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.programImage.image = UIImage(data: data!)
                    }
                }.resume()
            }
        }else if daySegment.selectedSegmentIndex == 3{
            wednesdayShow = wednesdayProgram[number]
            cell?.programName.text = wednesdayShow.title
            
            if let url = URL(string: wednesdayShow.imageUrl){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.programImage.image = UIImage(data: data!)
                    }
                }.resume()
            }
        }else if daySegment.selectedSegmentIndex == 4{
            thursdayShow = thursdayProgram[number]
            cell?.programName.text = thursdayShow.title
            
            if let url = URL(string: thursdayShow.imageUrl){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.programImage.image = UIImage(data: data!)
                    }
                }.resume()
            }
        }else if daySegment.selectedSegmentIndex == 5{
            fridayShow = fridayProgram[number]
            cell?.programName.text = fridayShow.title
            
            if let url = URL(string: fridayShow.imageUrl){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.programImage.image = UIImage(data: data!)
                    }
                }.resume()
            }
        }else if daySegment.selectedSegmentIndex == 6{
            saturdayShow = saturdayProgram[number]
            cell?.programName.text = saturdayShow.title
            
            if let url = URL(string: saturdayShow.imageUrl){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        cell?.programImage.image = UIImage(data: data!)
                    }
                }.resume()
            }
        }
        return cell!
    }
    
    @IBAction func changeWeekDaySegment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
          case 1:
            if self.mondayProgram.count == 0{
             self.getMondayProgram()
            }
          case 2:
            if self.tuesdayProgram.count == 0{
             self.getTuesdayProgram()
            }
          case 3:
            if self.wednesdayProgram.count == 0{
              self.getWednesdayProgram()
            }
          case 4:
            if self.thursdayProgram.count == 0{
             self.getThursdayProgram()
            }
          case 5:
            if self.fridayProgram.count == 0{
              self.getFridayProgram()
            }
          case 6:
            if self.saturdayProgram.count == 0{
             self.getSaturdayProgram()
            }
        default:
            if self.sundayProgram.count == 0{
             self.getSundayProgram()
            }
        }
        
        
        DispatchQueue.main.async {
            self.ScheduleView.reloadData()
        }
    }
    

    func ifNoConnection(){
        let alertController = UIAlertController(title: " No Internet Collection ", message: "Make sure that Wi-Fi or cellular data is turned on" ,preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
