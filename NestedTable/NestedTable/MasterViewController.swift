//
//  MasterViewController.swift
//  NestedTable
//
//  Created by Adarsh V C on 28/10/17.
//  reachadarshvc@gmail.com
//

import UIKit

class SubTableViewCell: UITableViewCell{
    
    typealias SubTableCellClickListner  = (_ title: String?) -> ()
    internal var aSubTableCellClickListner: SubTableCellClickListner?
    
    func onSubTableCellEditListner( subTableCellClickListner: @escaping SubTableCellClickListner) {
        self.aSubTableCellClickListner = subTableCellClickListner
    }
    
    static let nib: UINib = UINib(nibName: "SubCell", bundle: nil)
    static let reuseIdentifier = "kSubCell"
    
    @IBOutlet weak var buttonSubTableCell: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    var title = "" {
        didSet{
            
            buttonSubTableCell.setTitle(title, for:UIControlState.normal)
        }
    }
    
    @IBAction func buttonActionSubCell(_ sender: Any) {
        aSubTableCellClickListner?(title)
    }
}

class MasterTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    typealias MasterCellListner  = (_ name: String?, _ category: String?) -> ()
    internal var aMasterCellListner: MasterCellListner?
    
    static let nib: UINib = UINib(nibName: "CustomCell", bundle: nil)
    static let reuseIdentifier = "kMasterCell"
    
    var model = Model () {
        didSet {
            labelMasterCellTitle.text = model.title
            subTableView.reloadData()
        }
    }
    
    func onMasterCellEvent(masterCellListner: MasterCellListner?) {
        self.aMasterCellListner = masterCellListner
    }

    @IBOutlet weak var labelMasterCellTitle: UILabel!
    @IBOutlet weak var subTableView: UITableView!
    
    override func awakeFromNib() {
        subTableView.register(SubTableViewCell.nib, forCellReuseIdentifier: SubTableViewCell.reuseIdentifier)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = subTableView.dequeueReusableCell(withIdentifier: SubTableViewCell.reuseIdentifier) as! SubTableViewCell
        cell.title  = model.objects[indexPath.row] as String
        cell.onSubTableCellEditListner{ (name) in
            self.aMasterCellListner?(name, self.model.title)
        }
        
        return cell
    }
}

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var objects = [Model]()

    @IBOutlet weak var masterTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterTableView.register(MasterTableViewCell.nib, forCellReuseIdentifier: MasterTableViewCell.reuseIdentifier)
        
        objects = getMasterObjects()
        masterTableView.reloadData()
    }
    
    func getMasterObjects() -> [Model] {
        
        let modelOne = Model()
        modelOne.title = "Animals"
        modelOne.objects = ["Lion","Tiger","Elephant"]
        
        let modelTwo = Model()
        modelTwo.title = "Birds"
        modelTwo.objects = ["Parrot","Owl","Penguin"]
        
        return [modelOne,modelTwo]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Segues

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = masterTableView.dequeueReusableCell(withIdentifier: MasterTableViewCell.reuseIdentifier) as! MasterTableViewCell
        cell.model = objects[indexPath.row]
        cell.onMasterCellEvent { (name, category) in
            
            guard let aName = name, let aCategory = category else {
                return
            }
            self.masterTableView.reloadData()
            print("Clicked on \(aName) from \(aCategory)")
        }
        
        return cell
    }
}
