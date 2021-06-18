func uploadImage(paramName: String, fileName: String, images: [UIImage]) {
      let url = URL(string: "YOUR_URL")

      let boundary = UUID().uuidString

      let session = URLSession.shared

      var urlRequest = URLRequest(url: url!)
      urlRequest.httpMethod = "POST"


      urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

      var data = Data()

      var ctr = 0

      for img in images {
          data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
          let filename = fileName + String(ctr)

          data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
          data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
          data.append(img.pngData()!)

          ctr += 1
      }
      data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
      //print(String(decoding: data, as: UTF8.self))
      session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
          if error == nil {
              let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
              if let json = jsonData as? [String: Any] {
                  print(json)
              }
          }
      }).resume()
  }



  let img = UIImage(named: "Image")!
  let img1 = UIImage(named: "Image-1")!
  let img2 = UIImage(named: "Image-2")!

  uploadImage(paramName: "files", fileName: "image", images: [img, img2])
