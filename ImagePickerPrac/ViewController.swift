//
//  ViewController.swift
//  ImagePickerPrac
//
//  Created by Chun-Li Cheng on 2022/6/30.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "plus"),
                        style: .plain,
                        target: self,
                        action: #selector(buttonTapped))
    }
    
    private func addAlertController() { }

    @objc func buttonTapped() {
//        addAlertController()
        let ac = UIAlertController(title: "", message: "所有項目", preferredStyle: .actionSheet)
        
        let pictureAction = UIAlertAction(title: "相片", style: .default) { act in
            print("以相片呈現")
        }
        let videoAction = UIAlertAction(title: "影片", style: .default) { act in
            print("以影片呈現")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(pictureAction)
        ac.addAction(videoAction)
        ac.addAction(cancelAction)
        
        /// 當宣告時已設定 preferStyle, 這邊的 modalPresentationStyle 就不起作用
//        ac.modalPresentationStyle = .popover
//        let popover = ac.popoverPresentationController
//        popover?.barButtonItem = self.navigationItem.rightBarButtonItem
//        self.navigationItem.rightBarButtonItem =         ac.popoverPresentationController?.barButtonItem
        
        present(ac, animated: true)
    }
    
    /* buttonTapped 會覆蓋掉 IBAction，因 runtime 重新加入了 button，
     * 也等於以二進制重新再編譯一次
     */
//    @IBAction func ibButtonTapped(_ sender: UIBarButtonItem) {
//        print("ibButtonTapped.")
//    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        selectPhoto()
    }
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        takePhoto()
    }
    
}

// 需遵循此兩 protocol
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPhoto() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        /* delegate 遵循 (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
         */
        controller.delegate = self
        present(controller, animated: true)
     }
    
    func takePhoto() {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        // allowsEditing 即是拍照後，可再調整景框、構圖
        controller.allowsEditing = true
        
        controller.delegate = self
        present(controller, animated: true)
    }
    
    // delegation 的方法, 可依照 sourceType 去分別做出不同行為
    func imagePickerController(_ picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
//        let url = info[.imageURL] as? URL
//        if let url = url {
//            print(url)
//        }
        
        // MARK: - 測試，相簿中的照片沒有 metadata，但拍照後的檔案有
        let meta = info[.mediaMetadata]
        print(meta as Any)
        let mediaType = info[.mediaType]
        print(mediaType as Any)

        if picker.sourceType == .camera {
            // 已編輯過的相片，存到 Album 中
            let image = info[.editedImage] as? UIImage
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
            imageView.image = image

        } else {
            // 選取 Album 中的相片並設定 imageView
            let image = info[.originalImage] as? UIImage
            imageView.image = image
        }
        // 不是這樣用滴
//        picker.resignFirstResponder()
        dismiss(animated: true)
    }
    
    // 在 Album 或 Camera 模式 cancel 時，本來就會 dismiss，若要處理其他事可在此編寫
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel.")
        dismiss(animated: true)
    }

}

extension ViewController: UIPopoverPresentationControllerDelegate {
//    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
//    }
}

