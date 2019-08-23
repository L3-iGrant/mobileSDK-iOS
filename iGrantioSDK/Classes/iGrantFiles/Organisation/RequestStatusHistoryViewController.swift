//
//  RequestStatusHistoryViewController.swift
//  iGrant
//
//  Created by Mohamed Rebin on 30/06/19.
//  Copyright © 2019 iGrant.com. All rights reserved.
//

import SDStateTableView
import UIKit

class RequestStatusHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var orgId: String?
    var histories: [RequestStatus]?
    @IBOutlet var historyListTable: SDStateTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        callHistoryListApi()
        navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
    }

    func callHistoryListApi() {
        addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getRequestedStatus(orgId: orgId ?? "")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CustomTabelCell.KRequestedStatusCellID, for: indexPath) as! RequestStatusTableViewCell
        cell.statusType.text = histories?[indexPath.row].TypeStr
        cell.showDate(dateval: histories?[indexPath.row].RequestedDate ?? "")
        cell.statusDetail.text = histories?[indexPath.row].StateStr

        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = .white
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let downloadDataProgressVC = storyboard?.instantiateViewController(withIdentifier: "DownloadDataProgressViewController") as! DownloadDataProgressViewController
        downloadDataProgressVC.organisationId = orgId
        downloadDataProgressVC.requestStatus =  histories?[indexPath.row]
        downloadDataProgressVC.fromHistory = true
        navigationController?.pushViewController(downloadDataProgressVC, animated: true)
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

extension RequestStatusHistoryViewController: WebServiceTaskManagerProtocol {
    func didFinishTask(from manager: AnyObject, response: (data: RestResponse?, error: String?)) {
        removeLoadingIndicator()
        if response.error != nil {
            showErrorAlert(message: (response.error)!)
            return
        }
        if let serviceManager = manager as? OrganisationWebServiceManager {
            if serviceManager.serviceType == .getRequestedStatus {
                if let data = response.data?.responseModel as? RequestedStatusHistory {
                    if histories == nil {
                        histories = [RequestStatus]()
                    }
//                    if serviceManager.isLoadMore {
//                        self.histories?.append(contentsOf: data.consentHistory)
//
//                    }else {
                    histories = data.DataRequests
                    if (self.histories?.count ?? 0) < 1 {
                        historyListTable.setState(.withImage(image: nil, title: "", message: NSLocalizedString("No history available", comment: "")))
                    }
                }
                DispatchQueue.main.async {
                    self.historyListTable.reloadData()
                }
            }
        }
    }
}
