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
import { Picker } from 'emoji-picker-element';

let Hooks = {}

function extractMessageIdFromElementId(element) {
    return element.id.split(/-(.*)/s)[1]
}

function triggerMessageDeletionEvent(event, component) {
    if (event.relatedTarget != undefined) {
        elementType = event.relatedTarget.localName 
        elementAction = event.relatedTarget.id.split(/-(.*)/s)[0]
        if (elementType != undefined && elementType == "button" && elementAction == "delete") {
            component.pushEvent("delete_message", {"id": extractMessageIdFromElementId(event.srcElement)}) 
        }
    }
}

function addClickEventListenerOnMessageSettingsButton(component) {
    component.el.addEventListener("click", event => {
        event.target.focus()
        elementId = "settings-" + extractMessageIdFromElementId(event.srcElement)
        document.getElementById(elementId).toggleAttribute("hidden")
    })
}

function addFocusOutEventListenerOnMessageSettingsButton(component) {
    component.el.addEventListener("focusout", event => {
        elementId = "settings-" + extractMessageIdFromElementId(event.srcElement)
        document.getElementById(elementId).setAttribute("hidden", "hidden")
        triggerMessageDeletionEvent(event, component)
    })
}

function addClickEventListenerOnMessageSettingsPopup(component) {
    component.el.addEventListener("click", event => {
        event.target.focus()
        elementId = "settings-" + extractMessageIdFromElementId(event.srcElement)
        document.getElementById(elementId).setAttribute("hidden", "hidden")
    })
}

function addPointerLeaveListenerOnMessageSettingsPopup(component) {
    component.el.addEventListener("pointerleave", event => {
        messageId = event.srcElement.id.split(/-(.*)/s)[1]
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
});

document.querySelector('emoji-picker').addEventListener('emoji-click', event => {
    textareaElement.value += event.detail.unicode
    emojiPopup.setAttribute("hidden", "hidden")
});

