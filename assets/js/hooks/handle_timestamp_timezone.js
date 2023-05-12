function adaptUtcTimestampToUserTimezone(component) {
    const dateElement = document.getElementById(component.el.id)
    const utcTimestamp = dateElement.innerHTML.trim()
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