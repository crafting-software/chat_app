function extractActionAndMessageIdFromDomElementId(element) {
    return element.id.split(/-(.*)/s)
}

function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time))
}

function toggleMessageNotifierButtonVisibility(button) {
    
}

export {extractActionAndMessageIdFromDomElementId, delay}