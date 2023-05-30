const GetUsername = {
    mounted() {
        const username = localStorage.getItem("username") 
        this.pushEvent("get_username", {"username": username})
    }
}

export { GetUsername }