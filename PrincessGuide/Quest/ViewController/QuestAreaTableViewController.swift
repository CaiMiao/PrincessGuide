//
//  QuestAreaTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class QuestAreaTableViewController: UITableViewController, DataChecking {
    
    private var areas = [Area]()
    
    let refresher = RefreshHeader()
    
    let backgroundImageView = UIImageView()

    let areaType: AreaType
    
    init(areaType: AreaType) {
        self.areaType = areaType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            let navigationBar = themable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themable.backgroundImageView.image = theme.backgroundImage
            themable.refresher.arrowImage.tintColor = theme.color.indicator
            themable.refresher.loadingView.color = theme.color.indicator
            themable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateConsoleVariblesEnd, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        navigationItem.title = NSLocalizedString("Quests", comment: "")
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(QuestAreaTableViewCell.self, forCellReuseIdentifier: QuestAreaTableViewCell.description())
        tableView.rowHeight = 66
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        loadData()
    }
    
    @objc private func handleUpdateEnd(_ notification: NSNotification) {
        loadData()
    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Master.shared.getAreas(type: self?.areaType, callback: { (areas) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.areas = areas.sorted { $0.areaId > $1.areaId }
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestAreaTableViewCell.description(), for: indexPath) as! QuestAreaTableViewCell
        
        cell.configure(for: areas[indexPath.row].areaName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = areas[indexPath.row]
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            area.quests.forEach { $0.preload() }
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                let vc = QuestTabViewController(quests: area.quests)
                vc.navigationItem.title = area.areaName
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
