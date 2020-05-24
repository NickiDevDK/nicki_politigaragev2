const nicki = new Vue({
    el: "#nicki",

    data: {
        // Shared
        ResourceName: "nicki_politigaragev2",
        showUI: false,

    },

    methods: {

        // START OF MAIN MENU
        OpenUIMenu() {
            this.showUI     = true;
        },

        CloseMenu() {
            axios.post(`http://${this.ResourceName}/CloseMenu`, {}).then((response) => {
                this.showUI        = false;
            }).catch((error) => { });
        },

        Choose1() {
            axios.post(`http://${this.ResourceName}/Choose1`, {}).then((response) => {
                this.showUI        = false;
            }).catch((error) => { });
        },

        Choose2() {
            axios.post(`http://${this.ResourceName}/Choose2`, {}).then((response) => {
                this.showUI        = false;
            }).catch((error) => { });
        },

        Choose3() {
            axios.post(`http://${this.ResourceName}/Choose3`, {}).then((response) => {
                this.showUI        = false;
            }).catch((error) => { });
        },
    },
});

// Listener from Lua CL
document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "openUIMenu") {
                nicki.OpenUIMenu();
            }
        });
    }
}
