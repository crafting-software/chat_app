function adaptUtcTimestampToUserTimezone(component) {
    let dateElement = document.getElementById(component.el.id)
    let utcTimestamp = dateElement.innerHTML.trim()
    dateElement.innerHTML = new Date(utcTimestamp).toLocaleString('en-GB')
}

const HandleTimestampTimezone = {
    mounted() {
        adaptUtcTimestampToUserTimezone(this)
    },

    updated() {
        adaptUtcTimestampToUserTimezone(this)
    }
}

export { HandleTimestampTimezone }