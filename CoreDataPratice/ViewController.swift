//
//  ViewController.swift
//  CoreDataPratice
//
//  Created by 하연주 on 2023/12/08.
//

import UIKit
import CoreData

struct Person{
    var name : String
    var email : String
}

class ViewController: UIViewController {
    private let tableView = UITableView()
    
    var listArray : [Int] = [0,1,2,3,4]
    
    private let addBtn : UIButton = {
        var btn = UIButton()
        btn.setTitle("추가", for: .normal)
        btn.backgroundColor = .brown
        btn.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let delBtn : UIButton = {
        var btn = UIButton()
        btn.setTitle("삭제", for: .normal)
        btn.backgroundColor = .brown
        btn.addTarget(self, action: #selector(delBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let btnsStackView : UIStackView = {
        var sv = UIStackView()
        sv.alignment = .center
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 50

        return sv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTableView()
        setupConstraints()
        
        saveAtcoreData()
    }
    
    func saveAtcoreData() {
        //core data에 저장하고 싶은 데이터..!!
        let heidi = Person(name: "heidi", email: "heidi@ggg.com")
        
        //NSPersistentContainer으로부터 NSManagedObjectContext를 가져옴
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext //NSPersistentContainer 타입에 viewContext라는 프로퍼티가 있어서 가능
        
        
        //Entity를 가져옴 - 내가 원하는 데이터들을 어떤 Entity에 attribute로 저장하고 싶은데!
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: context)
        
        //NSManagedObject를 만든다 -
        if let entity = entity {
            let profile = NSManagedObject(entity: entity, insertInto: context)
            
            //NSManagedObject에 값을 세팅
            //앞서 지정해줬던 entity에 그 안에 생성해준 attribute이름을 "키"로 해서 저장해준다
            profile.setValue(heidi.name, forKey: "name")
            profile.setValue(heidi.email, forKey: "email")
            
            
            do {
              try context.save()  //NSManagedObjectContext에 있는 save 메서드로 core data에 저장해준다
            } catch {
              print(error.localizedDescription)
            }

        }
        
    }
    
    func setupConstraints () {
        btnsStackView.addArrangedSubview(addBtn)
        btnsStackView.addArrangedSubview(delBtn)
        
        view.addSubview(btnsStackView)
        btnsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            btnsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: btnsStackView.safeAreaLayoutGuide.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            
        ])
        
        //⭐️테이블뷰⭐️ 테이블뷰의 오토레이아웃 설정
    }

    func setupTableView() {
        //⭐️테이블뷰⭐️ 델리게이트 패턴의 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        //⭐️테이블뷰⭐️ 셀의 높이 설정
        tableView.rowHeight = 120
        
        //⭐️테이블뷰⭐️ 셀의 등록과정⭐️⭐️⭐️ (스토리보드 사용시에는 스토리보드에서 자동등록)
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.cellID)
    }
    
    @objc func addBtnTapped() {
        print("눌렀다")
        self.listArray.append(listArray.count)
        self.tableView.reloadData() //항목추가하고 업데이트된 데이터로 테이블뷰 리로드
        print(listArray)
        
        
        //코어데이터에 저장한거 불러와보기
        fetchProfile()
        
    }
    
    @objc func delBtnTapped() {
        print("눌렀다")
        listArray.removeLast()
        self.tableView.reloadData() //항목추가하고 업데이트된 데이터로 테이블뷰 리로드
        print(listArray)
    }
    
    func fetchProfile() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
            
        do {
           let contact = try context.fetch(Profile.fetchRequest()) as! [Profile]
           contact.forEach {
              print($0.name)
          }
        } catch {
           print(error.localizedDescription)
        }
    }
    
    
    
}


//⭐️테이블뷰⭐️ 필수 프로토콜 채랙
extension ViewController: UITableViewDataSource {
    
    //⭐️테이블뷰⭐️ 1) 테이블뷰에 몇개의 데이터를 표시할 것인지(셀이 몇개인지)를 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return listArray.count
    }
    
    //⭐️테이블뷰⭐️ 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        
        // (힙에 올라간)재사용 가능한 셀을 꺼내서 사용하는 메서드 (애플이 미리 잘 만들어 놓음)
        // (사전에 셀을 등록하는 과정이 내부 메커니즘에 존재)
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.cellID, for: indexPath) as! MyTableViewCell

        cell.label.text = String(listArray[indexPath.row])
        
        return cell
    }
}

//⭐️테이블뷰⭐️ 필수 프로토콜 채랙
extension ViewController: UITableViewDelegate {
    
    //⭐️테이블뷰⭐️ 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 다음화면으로 이동

    }
}

