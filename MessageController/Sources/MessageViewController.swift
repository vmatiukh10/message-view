//
//  MessageViewController.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    lazy var loaderView: UIView = {
        UIActivityIndicatorView(style: .large)
    }()
    
    var viewModel = MessageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: MessageCell.self)
        viewModel.$messages.subscribe(self) { this, messages in
            this.tableView.reloadData()
            this.updateTableViewOffset()
        }
        viewModel.$isFetchingData.subscribe(self) { this, isLoading in
            if isLoading {
                this.view.addSubview(this.loaderView)
                this.loaderView.center = this.view.center
            } else {
                this.loaderView.removeFromSuperview()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func updateTableViewOffset() {
        let offset = tableView.bounds.height - tableView.contentSize.height
        guard offset > 0 else {
            tableView.contentInset = .zero
            return
        }
        tableView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
        scrollToBottom()
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        guard let message = textField.text, !message.isEmpty else {
            return
        }
        viewModel.send(message: message)
        textField.text = nil
    }
    
    @IBAction func loadMoreMessages() {
        viewModel.loadMessages()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            setBottomSpacing(keyboardSize.height - view.safeAreaInsets.bottom)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification:Notification) {
        setBottomSpacing(0)
    }
    
    func setBottomSpacing(_ spacing: CGFloat) {
        UIView.animate(withDuration: 0.35) {
            self.bottomConstraint.constant = spacing
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.updateTableViewOffset()
        }
    }
    
    @objc
    func editAction(_ indexPath: IndexPath) {
        
    }
}

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeue(cellForItemAt: indexPath)
        let message = viewModel.messages[indexPath.row]
        cell.config(message.body,
                    time: message.created.formatted(date: .omitted, time: .shortened))
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(actionProvider:  { actons in
            let editAction = UIAction(title: "Edit") { [weak self] _ in
                self?.editAction(indexPath)
            }
            return UIMenu(title: "Message action", children: [editAction])
        })
    }
    func scrollToBottom()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.scrollToRow(at: .init(row: (self.viewModel.messages.count - 1), section: 0), at: .bottom, animated: true)
        }
    }
}


extension MessageViewController: MessageSendingProtocol {
    func messageDidSend() {
        scrollToBottom()
    }
}
