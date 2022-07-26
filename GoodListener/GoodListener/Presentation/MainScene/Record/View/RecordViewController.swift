//
//  RecordViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/26.
//

import UIKit

class RecordViewController: UIViewController {
    
    weak var coordinator: RecordCoordinating?

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "Record"
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.backgroundColor = .white
        
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
