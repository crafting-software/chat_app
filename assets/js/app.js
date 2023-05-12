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

<<<<<<< HEAD
import "./room-modal"
=======
import "./room-modal.js"
// let Hooks = {}

function extractActionAndMessageIdFromDomElementId(element) {
    return element.id.split(/-(.*)/s)
}

function triggerMessageDeletionEvent(event, component) {
    if (event.relatedTarget != undefined) {
        elementType = event.relatedTarget.localName 
        elementAction = extractActionAndMessageIdFromDomElementId(event.relatedTarget)[0]
        if (elementType != undefined && elementType == "button" && elementAction == "delete") {
            component.pushEvent("delete_message", {"id": extractActionAndMessageIdFromDomElementId(event.srcElement)[1]}) 
        }
    }
}

function addClickEventListenerOnMessageSettingsButton(component) {
    component.el.addEventListener("click", event => {
        event.target.focus()
        elementId = "settings-" + extractActionAndMessageIdFromDomElementId(event.srcElement)[1]
        document.getElementById(elementId).toggleAttribute("hidden")
    })
}

function addFocusOutEventListenerOnMessageSettingsButton(component) {
    component.el.addEventListener("focusout", event => {
        elementId = "settings-" + extractActionAndMessageIdFromDomElementId(event.srcElement)[1]
        document.getElementById(elementId).setAttribute("hidden", "hidden")
        triggerMessageDeletionEvent(event, component)
    })
}

function addClickEventListenerOnMessageSettingsPopup(component) {
    component.el.addEventListener("click", event => {
        event.target.focus()
        elementId = "settings-" + extractActionAndMessageIdFromDomElementId(event.srcElement)[1]
        document.getElementById(elementId).setAttribute("hidden", "hidden")
    })
}

function addPointerLeaveListenerOnMessageSettingsPopup(component) {
    component.el.addEventListener("pointerleave", event => {
        messageId = extractActionAndMessageIdFromDomElementId(event.srcElement)[1]
        document.getElementById("settings-" + messageId).setAttribute("hidden", "hidden")
        document.getElementById("button-" + messageId).blur()
    })
}

function adaptUtcTimestampToUserTimezone(component) {
    dateElement = document.getElementById(component.el.id)
    utcTimestamp = dateElement.innerHTML
    dateElement.innerHTML = new Date(utcTimestamp).toLocaleString().replace(",", "")
}

Hooks.OpenMessageSettings = {
    mounted() {
        addClickEventListenerOnMessageSettingsButton(this)
        addFocusOutEventListenerOnMessageSettingsButton(this)
    } 
}

Hooks.CloseMessageSettings = {
    mounted() {
        addClickEventListenerOnMessageSettingsPopup(this)
        addPointerLeaveListenerOnMessageSettingsPopup(this)
    }
}

Hooks.HandleTimestampTimezone = {
    mounted() {
        adaptUtcTimestampToUserTimezone(this)
    },

    updated() {
        adaptUtcTimestampToUserTimezone(this)
    }
}

Hooks.SendMessageOnEnterKeyPress = {
    mounted() {
        this.el.addEventListener("keydown", (event) => {
            if (event.which === 13 && !event.shiftKey) {
                textareaElement = document.getElementById("message_textarea") 
                this.pushEvent("save_message",  {"text": textareaElement.value})
                textareaElement.value = ""
                textareaElement.blur()
            } 
        })
    }
}
<<<<<<< HEAD
import { Picker } from 'emoji-picker-element'
import { Hooks } from 'hooks'
<<<<<<< HEAD
>>>>>>> 7d6b0e8 (feat(3): removed * selector css)
>>>>>>> e5d059c (feat(3): removed * selector css)
=======
>>>>>>> ae72e07 (incorporated new room modal button)
=======
>>>>>>> 52697a2 (feat(3): resolved merge conflicts)

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    params: {_csrf_token: csrfToken},
    hooks: Hooks
})

// Show progress bar on live navigation and form submits

topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})

window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
<<<<<<< HEAD
=======

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


const container = document.querySelector('#container');
const rooms = document.querySelector('#divrooms');
const gradient = document.querySelector('#gradient');

container.addEventListener('scroll', function() {
  const wrapperHeight = container.offsetHeight;
  const contentHeight = rooms.offsetHeight;
  const scrollPosition = container.scrollTop;

  if (scrollPosition + wrapperHeight >= contentHeight) {
    gradient.style.display = 'none';
  } else {
    gradient.style.display = 'block';
  }
});
>>>>>>> be5d7df (feat(3): solved gradient div disappearing)
