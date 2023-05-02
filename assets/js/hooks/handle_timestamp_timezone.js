function adaptUtcTimestampToUserTimezone(component) {
    dateElement = document.getElementById(component.el.id)
    utcTimestamp = dateElement.innerHTML
    dateElement.innerHTML = new Date(utcTimestamp).toLocaleString().replace(",", "")
}

HandleTimestampTimezone = {
    mounted() {
        adaptUtcTimestampToUserTimezone(this)
    },

    updated() {
        adaptUtcTimestampToUserTimezone(this)
    }
}

export { HandleTimestampTimezone }