window.addEventListener("message", function(event) {
    const data = event.data;
    switch (data.action) {
        case "open":
            openMenu(data);
            break;
    }
})

function openMenu(data) {
    switch (data.ui) {
        case "vehicle":
            PrepareVehicleUi(data)
            document.getElementById("vehicle_background").style.background = `https://url/${data.vehicle}`;
            document.getElementById("vehcile_main").style.visibility = "visible";
            break
    }
}