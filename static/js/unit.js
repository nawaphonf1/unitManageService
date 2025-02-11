function getCookie(name) {
    let cookieArr = document.cookie.split(";");
    for (let i = 0; i < cookieArr.length; i++) {
        let cookie = cookieArr[i].trim();
        if (cookie.startsWith(name + "=")) {
            return cookie.substring(name.length + 1);
        }
    }
    return null;
}

// Use this function to retrieve the token
let token = getCookie("access_token");

// Redirect to home if no token
if (!token) {
    window.location.href = "/"; // Replace '/' with your homepage URL if different
}

// API endpoint URL
const apiUrl = "/api/unit/";

// Variables for pagination
let currentPage = 1;
const rowsPerPage = 10;

// Function to fetch and display units
async function fetchAndDisplayUnits(page = 1, position = '', dept = '', status = '',name = '') {
    try {
        // สร้าง query string เฉพาะพารามิเตอร์ที่มีค่า
        const queryParams = new URLSearchParams();
        queryParams.append("skip", (page - 1) * rowsPerPage);
        queryParams.append("limit", rowsPerPage);

        if (position) {
            queryParams.append("position_id", position);
        }
        if (dept) {
            queryParams.append("dept_id", dept);
        }
        if (status) {
            queryParams.append("status", status);
        }
        if (name) {
            queryParams.append("name", name);
        }

        // ส่งคำขอไปที่ API พร้อม query string
        const response = await fetch(`${apiUrl}?${queryParams.toString()}`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}` // Attach the token in the Authorization header
            }
        });

        if (response.status === 401) {
            alert("Session expired. Redirecting to the homepage.");
            window.location.href = "/"; // Replace '/' with your homepage URL
            return;
        }

        if (!response.ok) {
            throw new Error("Failed to fetch units.");
        }

        const data = await response.json();
        const tableBody = document.getElementById("unitTableBody");
        const pagination = document.getElementById("pagination");

        tableBody.innerHTML = ""; // Clear existing rows

        // Populate the table
        data.units.forEach((unit, index) => {
            let statusColor;
            let status;

            if(unit.status === "อยู่ในภารกิจ"){
                statusColor = "red";
                status = "อยู่ในภารกิจ"
            }else if(unit.status === "รอเริ่มภารกิจ"){
                statusColor = "yellow";
                status = "รอเริ่มภารกิจ" + "(" + formatDateToThai(unit.date_start) +" - "+formatDateToThai(unit.date_end) +  ")";
            }else if(unit.status === "ว่าง"){
                statusColor = "green";
                status = "ว่าง";
            }

            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${(page - 1) * rowsPerPage + index + 1}
                <td>
                    <img id="" src="${unit.img_path || "N/A"}" class="rounded mx-auto d-block mb-3" alt="units Image" style="max-width: 80px; max-height: 80px;">
                </td>

                <td>${unit.position_name || "N/A"}</td>
                <td>${unit.first_name} ${unit.last_name}</td>
                <td>${unit.dept_name || "N/A"}</td>
                <td>
                    <span class="status-circle" style="background-color: ${statusColor};"></span> ${status || "Active"}
                </td>
                <td>
                    <button class="btn btn-info btn-sm" data-id="${unit.units_id}" onclick="showMemberDetail(${unit.units_id})">รายละเอียด</button>
                    <button class="btn btn-warning btn-sm" data-id="${unit.units_id}" onclick="showMemberEdit(${unit.units_id})">แก้ไข</button>
                </td>
            `;
            tableBody.appendChild(row);
        });

        // Update pagination
        const totalPages = Math.ceil(data.total / rowsPerPage);
        updatePagination(totalPages, page);
    } catch (error) {
        console.error("Error fetching units:", error);
    }
}
function formatDateToThai(dateString) {
    const date = new Date(dateString);
    const day = date.getDate(); // วันที่
    const month = date.toLocaleString("th-TH", { month: "long" }); // ชื่อเดือนแบบไทย
    const year = date.getFullYear() + 543; // แปลง ค.ศ. เป็น พ.ศ.
    return `${day} ${month} ${year}`;
}

async function displayUnitsMission(unitId) {
    try {
        const response = await fetch(`/api/mission/units/${unitId}`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}` // Attach the token in the Authorization header
            }
        });

        if (response.status === 401) {
            alert("Session expired. Redirecting to the homepage.");
            window.location.href = "/"; // Replace '/' with your homepage URL
            return;
        }

        if (!response.ok) {
            throw new Error("Failed to fetch units.");
        }

        const data = await response.json();
        const tableBody = document.getElementById("missionTableBody");

        tableBody.innerHTML = ""; // Clear existing rows

        let num = 1; // เริ่มต้นตัวแปร num
        data.forEach((mission) => {
            let statusColor = null;
            if (mission.mission_status == 'r') {
                statusColor = "green";
            }
            else if (mission.mission_status == 'w') {
                statusColor = "yellow";
            }
            else
            {
                statusColor = "red";
            }

            // แปลงวันที่เริ่มต้นและสิ้นสุดเป็นแบบไทย
            const missionStartDate = formatDateToThai(mission.mission_start);
            const missionEndDate = formatDateToThai(mission.mission_end);

            const row = document.createElement("tr");

            row.innerHTML = `
                <td>${num}</td>
                <td>${mission.mission_name || "N/A"}</td>
                <td>${missionStartDate}</td>
                <td>${missionEndDate}</td>
                <td>
                    <span class="status-circle" style="background-color: ${statusColor};"></span> 
                </td>
            `;
            num += 1; // เพิ่มค่า num
            tableBody.appendChild(row);
        });

        // ฟังก์ชันแปลงวันที่เป็นรูปแบบไทย
        function formatDateToThai(dateString) {
            const date = new Date(dateString);
            const day = date.getDate(); // วันที่
            const month = date.toLocaleString("th-TH", { month: "long" }); // ชื่อเดือนแบบไทย
            const year = date.getFullYear() + 543; // แปลง ค.ศ. เป็น พ.ศ.
            return `${day} ${month} ${year}`;
        }
        // Update pagination
        const totalPages = Math.ceil(data.total / rowsPerPage);
        updatePagination(totalPages, page);
    } catch (error) {
        console.error("Error fetching units:", error);
    }
}

// Function to update pagination
function updatePagination(totalPages, currentPage) {
    const pagination = document.getElementById("pagination");
    pagination.innerHTML = ""; // Clear existing pagination
    const filterPosition = document.getElementById("filterPosition").value;
    const filterDept = document.getElementById("filterDept").value;
    const filterStatus = document.getElementById("filterStatus").value;
    const filterName = document.getElementById("filterName").value;

    for (let page = 1; page <= totalPages; page++) {
        const li = document.createElement("li");
        li.className = `page-item ${page === currentPage ? "active" : ""}`;
        li.innerHTML = `
            <a class="page-link" href="#">${page}</a>
        `;
        li.addEventListener("click", (event) => {
            event.preventDefault();
            fetchAndDisplayUnits(page, filterPosition, filterDept, filterStatus, filterName);
        });
        pagination.appendChild(li);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    async function showMemberDetail(unitId) {
        try {
            const response = await fetch(`${apiUrl}units/${unitId}`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${token}` // Attach the token in the Authorization header
                }
            });

            if (response.status === 401) {
                alert("Session expired. Redirecting to the homepage.");
                window.location.href = "/"; // Replace '/' with your homepage URL
                return;
            }

            if (!response.ok) {
                throw new Error("Failed to fetch unit details.");
            }

            const data = await response.json();

            // แสดงข้อมูลใน modal
            document.getElementById('units-img').src = data.img_path
            // document.getElementById("modalPositionName").textContent = data.position_name;
            document.getElementById("unitDetailName").innerHTML = "<strong class='pe-3'>ชื่อ:</strong> " + "<br>" + data.position_name + " " + data.first_name + " " + data.last_name;
            document.getElementById("deptDetailName").innerHTML = "<strong class='pe-3'>สังกัด:</strong> " + "<br>" + data.dept_name;
            document.getElementById("identifyIdDetail").innerHTML = "<strong class='pe-3'>หมายเลขประจำตัว:</strong> " + "<br>" + data.identify_id;
            document.getElementById("identifySoldierIdDetail").innerHTML = "<strong class='pe-3'>หมายเลขประจำตัวทหาร:</strong> " + "<br>" + data.identify_soldier_id;
            document.getElementById("telDetail").innerHTML = "<strong class='pe-3'>เบอร์โทร:</strong> " + "<br>" + data.tel;
            document.getElementById("bloodGroupDetail").innerHTML = "<strong class='pe-3'>กรุ๊ปเลือด:</strong> " + "<br>" + data.blood_group_id;
            document.getElementById("addressDetail").innerHTML = "<strong class='pe-3'>ที่อยู่:</strong> " + "<br>" + data.address_detail;



            // document.getElementById("modalTel").textContent = data.tel || "N/A";
            // document.getElementById("modalIdentifyId").textContent = data.identify_id || "N/A";
            // document.getElementById("modalStatus").textContent = data.status || "N/A";
            // document.getElementById("modalAddressDetail").textContent = data.address_detail || "N/A";

            // เก็บ member_id สำหรับการดาวน์โหลดรายงาน
            selectedUnitId = unitId;

            // เปิด modal
            const unitDetailModal = new bootstrap.Modal(document.getElementById("unitDetailModal"));
            unitDetailModal.show();
            displayUnitsMission(unitId);

        } catch (error) {
            console.error("Error fetching member details:", error);
            alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
        }
    }

    async function showMemberEdit(unitId) {
        try {
            const response = await fetch(`${apiUrl}units/${unitId}`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${token}` // Attach the token in the Authorization header
                }
            });

            if (response.status === 401) {
                alert("Session expired. Redirecting to the homepage.");
                window.location.href = "/"; // Replace '/' with your homepage URL
                return;
            }

            if (!response.ok) {
                throw new Error("Failed to fetch unit details.");
            }

            const data = await response.json();

            // โหลดข้อมูลตำแหน่งจาก API
            const positionResponse = await fetch(`/api/position`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${token}`
                }
            });

            if (!positionResponse.ok) {
                throw new Error("Failed to fetch positions.");
            }

            const positions = await positionResponse.json();

            // กำหนดตัวเลือกใน dropdown "ยศ"
            const positionDropdown = document.getElementById("unitEditPosition");
            positionDropdown.innerHTML = ""; // ลบตัวเลือกเก่า
            positions.forEach(position => {
                const option = document.createElement("option");
                option.value = position.position_id;
                option.textContent = position.position_name;
                if (position.position_id === data.position_id) {
                    option.selected = true; // ตั้งค่าตัวเลือก default
                }
                positionDropdown.appendChild(option);
            });

            // โหลดข้อมูลสังกัดจาก API
            const deptResponse = await fetch(`/api/dept/`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${token}`
                }
            });

            if (!deptResponse.ok) {
                throw new Error("Failed to fetch departments.");
            }

            const departments = await deptResponse.json();

            // กำหนดตัวเลือกใน dropdown "สังกัด"
            const deptDropdown = document.getElementById("deptEditName");
            deptDropdown.innerHTML = ""; // ลบตัวเลือกเก่า
            departments.forEach(dept => {
                const option = document.createElement("option");
                option.value = dept.dept_id;
                option.textContent = dept.dept_name;
                if (dept.dept_id === data.dept_id) {
                    option.selected = true; // ตั้งค่าตัวเลือก default
                }
                deptDropdown.appendChild(option);
            });

            // กำหนดค่าในฟิลด์อื่น
            document.getElementById("units-img-edit").src = data.img_path;

            document.getElementById("unitEditFirstName").value = data.first_name;
            document.getElementById("unitEditLastName").value = data.last_name;
            document.getElementById("identifyIdEdit").value = data.identify_id;
            document.getElementById("identifySoldierIdEdit").value = data.identify_soldier_id;
            document.getElementById("telEdit").value = data.tel;
            document.getElementById("bloodGroupEdit").value = data.blood_group_id;
            document.getElementById("addressEdit").value = data.address_detail;
            document.getElementById("save-edit-units").setAttribute("data-units-id", data.units_id);



            // เปิด modal
            const unitEditModal = new bootstrap.Modal(document.getElementById("unitEditModal"));
            unitEditModal.show();

        } catch (error) {
            console.error("Error fetching member details:", error);
            alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
        }
    }

    fetchAndDisplayUnits(currentPage)
    window.showMemberDetail = showMemberDetail;
    window.showMemberEdit = showMemberEdit;


    window.displayUnitsMission = displayUnitsMission; // ให้ฟังก์ชันใช้ได้ใน scope ทั่วไป
});

document.getElementById("add-upload-image-btn").addEventListener("click", async () => {
    const imageInput = document.getElementById("add-units-image");
    const unitsImg = document.getElementById("add-units-img");

    if (imageInput.files.length === 0) {
        alert("กรุณาเลือกไฟล์รูปภาพ");
        return;
    }

    const formData = new FormData();
    formData.append("file", imageInput.files[0]);

    try {
        const response = await fetch("/api/unit/upload-image", {
            method: "POST",
            body: formData,
        });

        if (!response.ok) {
            throw new Error("การอัพโหลดล้มเหลว");
        }

        const result = await response.json();

        alert("อัพโหลดรูปภาพสำเร็จ");
        unitsImg.src = result.imageUrl; // ตั้งค่ารูปภาพที่อัพโหลด
    } catch (error) {
        console.error("Error uploading image:", error);
        alert("การอัพโหลดรูปภาพผิดพลาด");
    }
});


document.getElementById("upload-image-btn").addEventListener("click", async () => {
    const imageInput = document.getElementById("units-image");
    const unitsImg = document.getElementById("units-img-edit");

    if (imageInput.files.length === 0) {
        alert("กรุณาเลือกไฟล์รูปภาพ");
        return;
    }

    const formData = new FormData();
    formData.append("file", imageInput.files[0]);

    try {
        const response = await fetch("api/unit/upload-image", {
            method: "POST",
            body: formData,
        });

        if (!response.ok) {
            throw new Error("การอัพโหลดล้มเหลว");
        }

        const result = await response.json();

        alert("อัพโหลดรูปภาพสำเร็จ");
        unitsImg.src = result.imageUrl; // ตั้งค่ารูปภาพที่อัพโหลด
    } catch (error) {
        console.error("Error uploading image:", error);
        alert("การอัพโหลดรูปภาพผิดพลาด");
    }
});

document.getElementById("save-edit-units").addEventListener("click", async () => {
    const unitEditPosition = document.getElementById("unitEditPosition").value;
    const unitEditFirstName = document.getElementById("unitEditFirstName").value;
    const unitEditLastName = document.getElementById("unitEditLastName").value;
    const identifyIdEdit = document.getElementById("identifyIdEdit").value;
    const deptEditName = document.getElementById("deptEditName").value;

    const identifySoldierIdEdit = document.getElementById("identifySoldierIdEdit").value;
    const telEdit = document.getElementById("telEdit").value;
    const bloodGroupEdit = document.getElementById("bloodGroupEdit").value;
    const addressEdit = document.getElementById("addressEdit").value;

    const unitsId = document.getElementById("save-edit-units").getAttribute("data-units-id");




    // ใช้ URL จากรูปที่อัพโหลด
    const unitsImg = document.getElementById("units-img-edit");
    const imgPath = unitsImg.src && unitsImg.style.display !== "none" ? unitsImg.src : null;

    const payload = {
        img_path: imgPath,
        position_id: unitEditPosition,
        first_name: unitEditFirstName,
        last_name: unitEditLastName,
        dept_id: deptEditName,
        identify_id: identifyIdEdit,
        identify_soldier_id: identifySoldierIdEdit,
        tel: telEdit,
        boold_group_id: bloodGroupEdit,
        address_detail: addressEdit
    };


    fetch(`/api/unit/${unitsId}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`
        },
        body: JSON.stringify(payload),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error("Network response was not ok " + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            alert("แก้ไขสำเร็จ!");
            location.reload();
        })
        .catch(error => {
            console.error("เกิดข้อผิดพลาด:", error);
            alert("เกิดข้อผิดพลาดในการแก้ไขข้อมูล");
        });

});


document.getElementById("unitAddModal").addEventListener("click", async () => {
    try {

        // โหลดข้อมูลตำแหน่งจาก API
        const positionResponse = await fetch(`/api/position`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            }
        });

        if (!positionResponse.ok) {
            throw new Error("Failed to fetch positions.");
        }

        const positions = await positionResponse.json();

        const positionDropdown = document.getElementById("unitAddPosition");

        // เก็บค่าที่เลือกไว้ก่อนหน้านี้ (ถ้ามี)
        const previousValue = positionDropdown.value;

        positionDropdown.innerHTML = ""; // ลบตัวเลือกเก่า
        positions.forEach(position => {
            const option = document.createElement("option");
            option.value = position.position_id;
            option.textContent = position.position_name;

            // ตั้งค่า selected หากตรงกับค่าที่เลือกไว้ก่อนหน้า
            if (position.position_id.toString() === previousValue) {
                option.selected = true;
            }

            positionDropdown.appendChild(option);
        });


        // โหลดข้อมูลสังกัดจาก API
        const deptResponse = await fetch(`/api/dept/`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            }
        });

        if (!deptResponse.ok) {
            throw new Error("Failed to fetch departments.");
        }

        const departments = await deptResponse.json();

        // กำหนดตัวเลือกใน dropdown "สังกัด"
        const deptDropdown = document.getElementById("deptAddName");

        // เก็บค่าที่เลือกไว้ก่อนหน้านี้ (ถ้ามี)
        const previousdeptDropdownValue = deptDropdown.value;

        deptDropdown.innerHTML = ""; // ลบตัวเลือกเก่า
        departments.forEach(dept => {
            const option = document.createElement("option");
            option.value = dept.dept_id;
            option.textContent = dept.dept_name;

            // ตั้งค่า selected หากตรงกับค่าที่เลือกไว้ก่อนหน้า
            if (dept.dept_id.toString() === previousdeptDropdownValue) {
                option.selected = true;
            }
            deptDropdown.appendChild(option);
        });

    } catch (error) {
        console.error("Error fetching member details:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
});


document.getElementById("save-add-units").addEventListener("click", async () => {
    try {
        const unitAddPosition = document.getElementById("unitAddPosition").value;
        const unitAddFirstName = document.getElementById("unitAddFirstName").value;
        const unitAddLastName = document.getElementById("unitAddLastName").value;
        const identifyIdAdd = document.getElementById("identifyIdAdd").value;
        const deptAddName = document.getElementById("deptAddName").value;

        const identifySoldierIdAdd = document.getElementById("identifySoldierIdAdd").value;
        const telAdd = document.getElementById("telAdd").value;
        const bloodGroupAdd = document.getElementById("bloodGroupAdd").value;
        const addressAdd = document.getElementById("addressAdd").value;

        const unitsImg = document.getElementById("add-units-img");
        const imgPath = unitsImg.src && unitsImg.style.display !== "none" ? unitsImg.src : null;

        const payload = {
            img_path: imgPath,
            position_id: unitAddPosition,
            first_name: unitAddFirstName,
            last_name: unitAddLastName,
            dept_id: deptAddName,
            identify_id: identifyIdAdd,
            identify_soldier_id: identifySoldierIdAdd,
            tel: telAdd,
            boold_group_id: bloodGroupAdd,
            address_detail: addressAdd
        };

        // โหลดข้อมูลตำแหน่งจาก API
        const positionResponse = await fetch(`/api/unit`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify(payload),
        });

        if (!positionResponse.ok) {
            throw new Error("Failed to fetch positions.");
        }

        if (positionResponse.ok) {
            window.location.reload();
        }

    } catch (error) {
        console.error("Error fetching member details:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
});

document.getElementById("filter-units").addEventListener("click", async () => {
    try {

        // โหลดข้อมูลตำแหน่งจาก API
        const positionResponse = await fetch(`/api/position`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            }
        });

        if (!positionResponse.ok) {
            throw new Error("Failed to fetch positions.");
        }

        const positions = await positionResponse.json();

        const positionDropdown = document.getElementById("filterPosition");

        // เก็บค่าที่เลือกไว้ก่อนหน้านี้ (ถ้ามี)
        const previousValue = positionDropdown.value;

        positionDropdown.innerHTML = ""; // ลบตัวเลือกเก่า
        const option2 = document.createElement("option");
        option2.value = '';
        option2.textContent = '';

        positionDropdown.appendChild(option2);
        positions.forEach(position => {  
            const option2 = document.createElement("option");
            option2.value = position.position_id;
            option2.textContent = position.position_name;

            // ตั้งค่า selected หากตรงกับค่าที่เลือกไว้ก่อนหน้า
            if (position.position_id.toString() === previousValue) {
                option2.selected = true;
            }

            positionDropdown.appendChild(option2);
        });


        // โหลดข้อมูลสังกัดจาก API
        const deptResponse = await fetch(`/api/dept/`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            }
        });

        if (!deptResponse.ok) {
            throw new Error("Failed to fetch departments.");
        }

        const departments = await deptResponse.json();

        // กำหนดตัวเลือกใน dropdown "สังกัด"
        const deptDropdown = document.getElementById("filterDept");

        // เก็บค่าที่เลือกไว้ก่อนหน้านี้ (ถ้ามี)
        const previousdeptDropdownValue = deptDropdown.value;

        deptDropdown.innerHTML = ""; // ลบตัวเลือกเก่า
        let o3 = 0; 

        const option = document.createElement("option");
        option.value = '';
        option.textContent = '';
        deptDropdown.appendChild(option);

        departments.forEach(dept => {
            const option = document.createElement("option");
            option.value = dept.dept_id;
            option.textContent = dept.dept_name;

            // ตั้งค่า selected หากตรงกับค่าที่เลือกไว้ก่อนหน้า
            if (dept.dept_id.toString() === previousdeptDropdownValue) {
                option.selected = true;
            }
            deptDropdown.appendChild(option);

        });

    } catch (error) {
        console.error("Error fetching member details:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
});

document.getElementById("submit-filter-units").addEventListener("click", async () => {
    try {
        const filterPosition = document.getElementById("filterPosition").value;
        const filterDept = document.getElementById("filterDept").value;
        const filterStatus = document.getElementById("filterStatus").value;
        const filterName = document.getElementById("filterName").value;


        // เรียก fetchAndDisplayUnits พร้อมค่าฟิลเตอร์
        await fetchAndDisplayUnits(1, filterPosition, filterDept, filterStatus, filterName);

        // ดึง instance ของ modal ที่เปิดอยู่
        const filterModal = bootstrap.Modal.getInstance(document.getElementById("filterModal"));
        filterModal.hide(); // ใช้ hide() เพื่อปิด modal
    } catch (error) {
        console.error("Error fetching member details:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
});

document.getElementById("import-excel").addEventListener("click", async () => {
    const importExcelModal = new bootstrap.Modal(document.getElementById("importExcelModal"));
    importExcelModal.show();
});

document.getElementById("import-file-excel").addEventListener("click", async () => {
    const fileInput = document.getElementById("file-excel");
    const formData = new FormData();
    formData.append("file", fileInput.files[0]);

    const deptResponse = await fetch(`/api/mission/import_excel`, {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${token}`
        },
        body: formData
    });

    if (!deptResponse.ok) {
        throw new Error("Failed to fetch departments.");
    }

    if (deptResponse.ok) {
        location.reload();
        alert('import ข้อมูลเสร็จสิ้น')
    }

});

