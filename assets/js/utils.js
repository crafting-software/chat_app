function extractActionAndMessageIdFromDomElementId(element) {
    return element.id.split(/-(.*)/s)
}

export {extractActionAndMessageIdFromDomElementId}