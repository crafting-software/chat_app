// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import { Picker } from 'emoji-picker-element'
import { Hooks } from './hooks'
import { delay } from "./utils"

import "./room-modal"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    params: {_csrf_token: csrfToken},
    hooks: Hooks
})

// Show progress bar on live navigation and form submits

topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})

const chatbox = document.getElementById("chatbox")
let messageNotifierButton = document.getElementById("message_notifier_button")
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())
window.addEventListener("phx:new_message", event => {
    console.log("New message event")
    const messageElementHeight = document.querySelector(".message").offsetHeight
    if (chatbox.scrollTop > chatbox.scrollHeight - 2 * chatbox.clientHeight)
        chatbox.scrollTop = chatbox.scrollHeight - messageElementHeight
})

window.addEventListener("phx:animate_typing_indicator", event => {
    console.log("Typing indicator animation event")
    console.log(event)
    var chatbox_anchor = document.getElementById("chatbox_anchor")
    if (event.detail.status) {
        chatbox_anchor.classList = []
        chatbox_anchor.classList.add("opened_typing_indicator")
    }
})

let lastScrollTopState = chatbox.scrollTop
chatbox.addEventListener("scroll", () => { 
    scrollTop = chatbox.scrollTop
    if (scrollTop > lastScrollTopState && scrollTop > chatbox.scrollHeight - 2 * chatbox.clientHeight) {
        console.log("scrolled down")
        if (!messageNotifierButton.hasAttribute("hidden")) {
            messageNotifierButton.setAttribute("hidden", "hidden") 
            messageNotifierButton.classList.remove("message_notifier_button_appearance")
            messageNotifierButton.classList.add("message_notifier_button_disappearance")
        }
    } else if (scrollTop < lastScrollTopState && scrollTop < chatbox.scrollHeight - 2 * chatbox.clientHeight) {
        console.log("scrolled up") 
        if (messageNotifierButton.hasAttribute("hidden")) {
            messageNotifierButton.classList.remove("message_notifier_button_disappearance")
            messageNotifierButton.removeAttribute("hidden") 
            messageNotifierButton.classList.add("message_notifier_button_appearance")
        }
    } 
    lastScrollTopState = scrollTop <= 0 ? 0 : scrollTop; 
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

let textareaElement = document.getElementById("message_textarea")
let emojiButton = document.getElementById("emoji_button")
let emojiPopup = document.querySelector('emoji-picker')

window.onclick = event => {
    ids = ["emoji_button", "emoji_popup"]
    if (!ids.includes(event.target.id))
        emojiPopup.setAttribute("hidden", "hidden")
}

emojiButton.addEventListener("click", event => {
    emojiPopup.toggleAttribute("hidden")
})

document.querySelector('emoji-picker').addEventListener('emoji-click', event => {
    textareaElement.value += event.detail.unicode
    emojiPopup.setAttribute("hidden", "hidden")
})

messageNotifierButton.addEventListener("click", () => {
    console.log("arrow button clicked")
    const messageElementHeight = document.querySelector(".message").offsetHeight
    chatbox.scrollTop = chatbox.scrollHeight - messageElementHeight
})
