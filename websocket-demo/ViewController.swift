import UIKit
import SwiftPhoenixClient

class ViewController: UIViewController {

    let socket = Phoenix.Socket(domainAndPort: "localhost:4000", path: "socket", transport: "websocket")
    let topic = "my_room:lobby"

    let newMessageEvent = "new_message"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setUpWebSocket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpWebSocket() {
        socket.join(topic: self.topic, message: Phoenix.Message(subject: "status", body: "joining")) { channel in
            let chan = channel as! Phoenix.Channel

            chan.on("join") { message in
                print("You joined the room.\n")
            }

            chan.on(self.newMessageEvent) { message in
                print("\(self.newMessageEvent): \(message)")
            }

            chan.on("user:entered") { message in
                print("user:entered: \(message)")
            }

            chan.on("error") { message in
                print("error: \(message)")
            }
        }
    }

    @IBAction func sendMessage(sender: AnyObject) {
        let message = Phoenix.Message(message: ["name": "kazu cocoa", "message": "hello, phoenix"])
        let payload = Phoenix.Payload(topic: self.topic, event: self.newMessageEvent, message: message)
        self.socket.send(payload)
    }
}
