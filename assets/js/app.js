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
<<<<<<< HEAD
import { Picker } from 'emoji-picker-element'
import { Hooks } from './hooks'

<<<<<<< HEAD
import "./room-modal"
=======
import "./room-modal.js"
=======
import { Picker } from 'emoji-picker-element';

import "./room-modal.js"
let Hooks = {}

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
import { Picker } from 'emoji-picker-element'
import { Hooks } from 'hooks'
>>>>>>> 7d6b0e8 (feat(3): removed * selector css)
>>>>>>> e5d059c (feat(3): removed * selector css)

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
