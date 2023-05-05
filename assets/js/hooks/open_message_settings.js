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

OpenMessageSettings = {
    mounted() {
        addClickEventListenerOnMessageSettingsButton(this)
        addFocusOutEventListenerOnMessageSettingsButton(this)
    } 
}

export { OpenMessageSettings }