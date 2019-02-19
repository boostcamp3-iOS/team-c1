//
//  PetViewController.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class PetViewController: UIViewController {

    private var isSelecting = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        isSelecting = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Identifier.goToKeywordVCSegue {
            guard let keywordVC = segue.destination as? KeywordViewController,
                let pet = sender as? Pet else {
                    let message = getErrorMessage(MyGoodsDataError.lostData)
                    alert(message)
                    return
            }
            keywordVC.sendData(pet)
        }
    }

    // MARK: - Action methods
    @IBAction func selecteDogAction(_ sender: Any) {
        let pet = Pet.dog
        if !isSelecting {
            performSegue(withIdentifier: Identifier.goToKeywordVCSegue, sender: pet)
        }
        isSelecting = !isSelecting
    }

    @IBAction func selectCatAction(_ sender: Any) {
        let pet = Pet.cat
        if !isSelecting {
            performSegue(withIdentifier: Identifier.goToKeywordVCSegue, sender: pet)
        }
        isSelecting = !isSelecting
    }
}

extension PetViewController: ErrorHandlerType {}

// MARK: - Private structures
extension PetViewController {
    private struct Identifier {
        static let goToKeywordVCSegue = "GoToKeywordViewController"
    }
}
