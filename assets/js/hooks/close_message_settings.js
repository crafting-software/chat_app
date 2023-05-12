import { extractActionAndMessageIdFromDomElementId } from "../utils"

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

const CloseMessageSettings = {
    mounted() {
        addClickEventListenerOnMessageSettingsPopup(this)
        addPointerLeaveListenerOnMessageSettingsPopup(this)
    }
}

export { CloseMessageSettings }