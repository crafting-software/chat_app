import { extractActionAndMessageIdFromDomElementId } from "../utils"

function triggerMessageDeletionEvent(event, component) {
    if (event.relatedTarget != undefined) {
        elementType = event.relatedTarget.localName 
        elementAction = extractActionAndMessageIdFromDomElementId(event.relatedTarget)[0]
        if (elementType != undefined && elementType == "button" && elementAction == "delete") {
            component.pushEvent("delete_message", {"id": extractActionAndMessageIdFromDomElementId(event.srcElement)[1]}) 
        }
    }
}

function addOpeningClickEventListenerOnMessageSettingsButton(component) {
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
    const messageId = extractActionAndMessageIdFromDomElementId(component.el)[1]
    const messageSettingsPopup = document.getElementById("settings-" + messageId)
    if (messageSettingsPopup != undefined) {
        document.addEventListener("click", event => {
            const isClickInside = messageSettingsPopup.contains(event.target) || component.el.contains(event.target)
            if (!isClickInside) {
                messageSettingsPopup.setAttribute("hidden", "hidden")
            } else {
                event.target.focus()
                messageSettingsPopup.removeAttribute("hidden")
            }
        })
    }
}

const MessageSettings = {
    mounted() {
        addOpeningClickEventListenerOnMessageSettingsButton(this)
        addFocusOutEventListenerOnMessageSettingsButton(this)
        addClickEventListenerOnMessageSettingsPopup(this)
    } 
}

export { MessageSettings }