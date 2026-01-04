import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Item {
    id: root
    width: 1280
    height: 800
    objectName: "Booking"
    signal continueBooking()
    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    // Properties for dates and calculations
    property string checkInDate: ""
    property string checkOutDate: ""
    property int nights: 0
    property double totalPrice: 0
    property StackView stackViewRef

    // == DỮ LIỆU PHÒNG ==
    ListModel {
        id: roomModel
    }

    // == PHÒNG ĐƯỢC CHỌN ==
    property var selectedRoom: ({})

    // Thêm cho phân trang và lọc
    property string currentFilter: "RoomType" // Giá trị filter mặc định
    property int itemsPerPage: 10 // Số phòng mỗi trang
    property int currentPage: 1 // Trang hiện tại
    property int totalPages: 0 // Tổng số trang (tính toán sau)
    property int maxVisiblePages: 5 // Số trang hiển thị tối đa trong thanh phân trang

    Component.onCompleted: {
        RoomController.getRooms();
    }

    Connections {
        target: RoomController
        function onRoomsFetched(rooms) {
            console.log("Rooms fetched or updated via signal, length: " + rooms.length); // Debug log để check signal trigger
            roomModel.clear();
            for (var i = 0; i < rooms.length; i++) {
                var room = rooms[i];
                room.visible = true; // Thêm property visible mặc định true
                roomModel.append(room);
            }
            updateVisibleItems(); // Cập nhật visible ngay sau khi load/update
        }
        function onRoomFetchFailed(errorMsg) {
            console.log("Failed to fetch rooms:", errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
        function onRoomSelected(room) {
            selectedRoom = room;
            console.log("Selected room:", room.roomId, room.roomNumber);
        }
        function onRoomBooked() {
            console.log("Room booked successfully");
            errorDialog.text = "Đặt phòng " + selectedRoom.roomNumber + " thành công!";
            errorDialog.open();
            RoomController.getRooms();
        }
        function onRoomBookingFailed(errorMsg) {
            console.log("Room booking failed:", errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
        function onRoomListChanged() {
            console.log("Room list changed, updating visible"); // Debug
            updateVisibleItems(); // Thêm để update pagination mà không reset model
        }
    }

    // Function to calculate nights and total
    function calculateNights() {
        if (checkInInput.text && checkOutInput.text) {
            let inDate = Date.fromLocaleString(Qt.locale(), checkInInput.text, "dd/MM/yyyy");
            let outDate = Date.fromLocaleString(Qt.locale(), checkOutInput.text, "dd/MM/yyyy");
            if (!isNaN(inDate) && !isNaN(outDate) && outDate > inDate) {
                nights = Math.ceil((outDate - inDate) / (1000 * 60 * 60 * 24));
                totalPrice = selectedRoom.price * nights;
                checkInDate = Qt.formatDate(inDate, "yyyy-MM-dd");
                checkOutDate = Qt.formatDate(outDate, "yyyy-MM-dd");
            } else {
                nights = 0;
                totalPrice = 0;
            }
        } else {
            nights = 0;
            totalPrice = 0;
        }
    }

    // Hàm cập nhật visible cho items dựa trên filter và page
    function updateVisibleItems() {
        var visibleCount = 0;
        // Loop 1: Đếm tổng số items khớp filter
        for (var i = 0; i < roomModel.count; i++) {
            var item = roomModel.get(i);
            var matchesFilter = (currentFilter === "RoomType" || item.roomType === currentFilter);
            if (matchesFilter) {
                visibleCount++;
            }
        }
        // Tính tổng trang
        totalPages = Math.ceil(visibleCount / itemsPerPage);
        if (totalPages === 0) totalPages = 1; // Ít nhất 1 trang
        if (currentPage > totalPages) currentPage = totalPages; // Reset nếu cần
        // Reset visibleCount cho page
        visibleCount = 0;
        var startIndex = (currentPage - 1) * itemsPerPage;
        var endIndex = startIndex + itemsPerPage;
        // Loop 2: Set visible chỉ cho items khớp filter và trong range page
        for (var j = 0; j < roomModel.count; j++) {
            var item2 = roomModel.get(j);
            var matchesFilter2 = (currentFilter === "RoomType" || item2.roomType === currentFilter);
            if (matchesFilter2) {
                item2.visible = (visibleCount >= startIndex && visibleCount < endIndex);
                visibleCount++;
            } else {
                item2.visible = false;
            }
            roomModel.set(j, item2); // Cập nhật model
        }
        console.log("Updated items: totalPages=" + totalPages + ", currentPage=" + currentPage + ", filter=" + currentFilter);
    }

    // == ERROR DIALOG ==
    Dialog {
        id: errorDialog
        modal: true
        focus: true
        title: "Thông báo"
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 300
        property alias text: errorText.text
        contentItem: Rectangle {
            color: "#ffffff"
            radius: 8
            border.color: "#ccc"
            border.width: 1
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                Text {
                    id: errorText
                    font.pixelSize: 14
                    color: "#333"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
                Button {
                    text: "OK"
                    Layout.fillWidth: true
                    onClicked: errorDialog.close()
                }
            }
        }
    }

    // ========== HEADER (THAY ĐỔI: Giống Places.qml) ==========
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#d32f2f"
        z: 1
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            Row {
                spacing: 40
                Layout.alignment: Qt.AlignVCenter
                Text {
                    text: "Room"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            // Ở Room rồi, không làm gì hoặc reload nếu cần
                            console.log("Already in Room");
                        }
                    }
                }
                Text {
                    text: "Others"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            stackViewRef.replace("qrc:/Pkg/MVC/Views/Places.qml", {stackViewRef: stackViewRef});
                        }
                    }
                }
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Muong Thanh Luxury HCM"
                color: "white"
                font.pixelSize: 20
                font.bold: true
            }
            Rectangle {
                id: avatar
                width: 40
                height: 40
                radius: 20
                color: "#ffebee"
                border.color: "#880e4f"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: UserController.getFirstName() && UserController.getLastName() ?
                          UserController.getFirstName()[0].toUpperCase() + UserController.getLastName()[0].toUpperCase() : "NA"
                    color: "#880e4f"
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: profileDialog.open()
                }
            }
        }
    }

    // ========== TITLE ==========
    Rectangle {
        id: titleBar
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "transparent"
        z: 1
        Text {
            anchors.centerIn: parent
            text: "Chọn phòng"
            font.pixelSize: 28
            font.bold: true
            color: "#333"
        }
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 6
            color: "#f5ecec"
        }
        Rectangle {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: 4
            width: parent.width * 0.35
            anchors.margins: 0
            color: "#b45b5b"
        }
    }

    // ========== Booking summary ==========
    Rectangle {
        id: bookingSummary
        width: 320
        height: 320
        radius: 8
        color: "#fafafa"
        border.color: "#ddd"
        border.width: 1
        z: 3
        anchors.top: titleBar.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 24
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8
            Rectangle {
                Layout.fillWidth: true
                height: 48
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Đơn đặt phòng của tôi"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#333"
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 48
                color: "#fff3f3"
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8
                    Text {
                        text: "Phòng:"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#333"
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Text {
                        text: selectedRoom.roomId || "Chưa chọn phòng"
                        font.pixelSize: 15
                        font.bold: true
                        color: "#7f2f2f"
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 36
                color: "#fff3f3"
                Text {
                    anchors.centerIn: parent
                    text: selectedRoom.roomType ? selectedRoom.roomType.charAt(0).toUpperCase() + selectedRoom.roomType.slice(1) : "Chưa chọn loại phòng"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#333"
                }
            }
            // Add date inputs
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                TextField {
                    id: checkInInput
                    placeholderText: "Nhận phòng (DD/MM/YYYY)"
                    Layout.fillWidth: true
                    onTextChanged: calculateNights()
                }
                TextField {
                    id: checkOutInput
                    placeholderText: "Trả phòng (DD/MM/YYYY)"
                    Layout.fillWidth: true
                    onTextChanged: calculateNights()
                }
            }
            // Display nights and dates if calculated
            ColumnLayout {
                visible: nights > 0
                spacing: 2
                RowLayout {
                    spacing: 8
                    Text { text: checkInInput.text.split('/')[0]; font.pixelSize: 20; font.bold: true; color: "#333" }
                    Text { text: "tháng " + checkInInput.text.split('/')[1]; font.pixelSize: 14; color: "#333" }
                    Text { text: "—"; font.pixelSize: 20; color: "#333" }
                    Text { text: checkOutInput.text.split('/')[0]; font.pixelSize: 20; font.bold: true; color: "#333" }
                    Text { text: "tháng " + checkOutInput.text.split('/')[1]; font.pixelSize: 14; color: "#333" }
                }
                RowLayout {
                    spacing: 12
                    ColumnLayout {
                        spacing: 2
                        Text { text: Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkInInput.text, "dd/MM/yyyy"), "dddd"); font.pixelSize: 12; color: "#555" }
                        Text { text: "từ lúc 14:00"; font.pixelSize: 12; color: "#555" }
                    }
                    ColumnLayout {
                        spacing: 2
                        Text { text: Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkOutInput.text, "dd/MM/yyyy"), "dddd"); font.pixelSize: 12; color: "#555" }
                        Text { text: "đến 12:30"; font.pixelSize: 12; color: "#555" }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 36
                color: "#fff3f3"
                visible: nights > 0
                Text {
                    anchors.centerIn: parent
                    text: nights + " đêm"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#333"
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "transparent"
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    Text {
                        text: nights > 0 ? Number(totalPrice).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : (selectedRoom.price ? Number(selectedRoom.price).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : "0 đ")
                        font.pixelSize: 24
                        font.bold: true
                        color: "#7f2f2f"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Button {
                        text: "Tiếp tục"
                        font.pixelSize: 22
                        background: Rectangle {
                            color: selectedRoom.roomId && selectedRoom.status === "available" && nights > 0 ? "#7f2f2f" : "#cccccc"
                            radius: 4
                        }
                        contentItem: Text {
                            text: parent.text
                            color: selectedRoom.roomId && selectedRoom.status === "available" && nights > 0 ? "white" : "#666666"
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        enabled: (selectedRoom.roomId !== "") && (selectedRoom.status === "available" ) && (nights > 0)
                        onClicked: {
                            stackViewRef.push("qrc:/Pkg/MVC/Views/Payment.qml", {
                                selectedRoom: selectedRoom,
                                checkInDate: checkInDate,
                                checkOutDate: checkOutDate,
                                nights: nights,
                                totalPrice: totalPrice,
                                stackViewRef: stackViewRef
                            });
                            continueBooking();
                        }
                    }
                }
            }
        }
    }

    // ========== MAIN SCROLL ==========
    ScrollView {
        id: mainScroll
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 12
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        clip: true
        z: 0
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            anchors.right: parent.right
        }
        Column {
            id: mainContent
            width: mainScroll.width
            spacing: 24
            anchors.topMargin: 8
            Row {
                id: contentRow
                width: mainContent.width
                spacing: 0
                Column {
                    id: leftColumn
                    width: mainScroll.width - bookingSummary.width - 48
                    spacing: 20
                    Rectangle {
                        width: leftColumn.width
                        height: 60
                        color: "#fffaf0"
                        radius: 8
                        border.color: "#ccc"
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            ComboBox {
                                id: roomTypeFilter
                                Layout.preferredWidth: 166
                                Layout.preferredHeight: 35
                                model: ["RoomType", "single", "double", "family"]
                                currentIndex: 0 // Mặc định chọn "RoomType"
                                Layout.alignment: Qt.AlignVCenter
                                onCurrentTextChanged: {
                                    currentFilter = currentText;
                                    currentPage = 1; // Reset về trang 1 khi filter thay đổi
                                    updateVisibleItems();
                                }
                            }
                            Item { Layout.fillWidth: true }
                        }
                    }
                    Repeater {
                        model: roomModel
                        delegate: Rectangle {
                            width: leftColumn.width
                            height: model.visible ? 220 : 0 // Height 0 nếu không visible
                            visible: model.visible // Sử dụng model.visible để lọc
                            radius: 12
                            color: "#fff"
                            border.color: "#e8e2e2"
                            border.width: 1
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16
                                Rectangle {
                                    Layout.preferredWidth: leftColumn.width * 0.32
                                    Layout.fillHeight: true
                                    radius: 8
                                    clip: true
                                    color: "#f0f0f0"
                                    Image {
                                        anchors.fill: parent
                                        source: image
                                        fillMode: Image.PreserveAspectCrop
                                    }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 6
                                    Text {
                                        text: roomId
                                        font.pixelSize: 20
                                        font.bold: true
                                    }
                                    Text {
                                        text: roomType.charAt(0).toUpperCase() + roomType.slice(1)
                                        font.pixelSize: 16
                                        color: "#444"
                                    }
                                    Text {
                                        text: description
                                        font.pixelSize: 14
                                        color: "#444"
                                        wrapMode: Text.WordWrap
                                    }
                                    RowLayout {
                                        spacing: 16
                                        Text { text: "👥 " + guests; font.pixelSize: 14 }
                                        Text { text: "📐 " + area; font.pixelSize: 14 }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 16
                                        Text {
                                            text: price ? Number(price).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : "0 đ"
                                            font.pixelSize: 18
                                            font.bold: true
                                            color: "#d32f2f"
                                        }
                                        Item { Layout.fillWidth: true }
                                        Button {
                                            text: status === "available" ? "Chọn" : "Đã đặt"
                                            width: 100
                                            height: 36
                                            enabled: status === "available"
                                            background: Rectangle {
                                                color: status === "available" ? "#7f2f2f" : "#cccccc"
                                                radius: 4
                                            }
                                            contentItem: Text {
                                                text: parent.text
                                                color: status === "available" ? "white" : "#666666"
                                                font.pixelSize: 14
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                            onClicked: {
                                                RoomController.selectRoom(roomId);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // Thanh phân trang
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 8
                        Button {
                            text: "Trước"
                            enabled: currentPage > 1
                            onClicked: {
                                currentPage--;
                                updateVisibleItems();
                            }
                        }
                        // Hiển thị tối đa 5 nút phân trang
                        Repeater {
                            model: {
                                var startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
                                var endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
                                startPage = Math.max(1, endPage - maxVisiblePages + 1);
                                var pageList = [];
                                for (var i = startPage; i <= endPage; i++) {
                                    pageList.push(i);
                                }
                                return pageList;
                            }
                            Button {
                                text: modelData.toString()
                                background: Rectangle {
                                    color: modelData === currentPage ? "#7f2f2f" : "#f0f0f0"
                                    radius: 4
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: modelData === currentPage ? "white" : "#333"
                                    font.pixelSize: 14
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: {
                                    currentPage = modelData;
                                    updateVisibleItems();
                                }
                            }
                        }
                        Button {
                            text: "Sau"
                            enabled: currentPage < totalPages
                            onClicked: {
                                currentPage++;
                                updateVisibleItems();
                            }
                        }
                    }
                    Rectangle { width: leftColumn.width; height: 16; color: "transparent" }
                }
                Item {
                    width: bookingSummary.width + 48
                }
            }
            Rectangle {
                id: footer
                width: mainContent.width
                height: 220
                color: "#001f3f"
                radius: 0
                border.width: 0
                anchors.horizontalCenter: mainContent.horizontalCenter
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 48
                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "fit@hcmus"
                            color: "#00cc99"
                            font.pixelSize: 20
                            font.bold: true
                        }
                        Label {
                            text: "Faculty of Information Technology,\nVNUHCM - University of Science"
                            color: "#ffffff"
                            wrapMode: Text.WordWrap
                        }
                    }
                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "Members"
                            color: "#00cc99"
                            font.pixelSize: 18
                            font.bold: true
                        }
                        Label { text: "• Phạm Hoàng Phúc"; color: "#ffffff" }
                        Label { text: "• Nguyễn Trực Phúc"; color: "#ffffff" }
                        Label { text: "• Nguyễn Khang Hy"; color: "#ffffff" }
                        Label { text: "• Lê Đinh Nguyên Phong"; color: "#ffffff" }
                    }
                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "Contact Us"
                            color: "#00cc99"
                            font.pixelSize: 18
                            font.bold: true
                        }
                        Label { text: "📞 0915 895 157"; color: "#ffffff" }
                        MouseArea {
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally("mailto:nkhy2414@clc.fitus.edu.vn")
                            Label {
                                text: "✉ nkhy2414@clc.fitus.edu.vn"
                                color: "#00ccff"
                                font.underline: true
                            }
                        }
                    }
                }
            }
        }
    }

    // ========== PROFILE DIALOG ==========
    Dialog {
        id: profileDialog
        modal: true
        focus: true
        x: parent.width - width - 40
        y: 70
        width: 340
        contentItem: Rectangle {
            width: parent.width
            color: "#ffffff"
            radius: 8
            border.color: "#ccc"
            border.width: 1
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                Text {
                    text: UserController.getFirstName() && UserController.getLastName() ?
                          UserController.getFirstName() + " " + UserController.getLastName() : "Guest"
                    font.bold: true
                    font.pixelSize: 16
                }
                Text {
                    text: UserController.getPhone() ? UserController.getPhone() : "No phone"
                    color: "#666"
                    font.pixelSize: 14
                }
                Rectangle {
                    color: "#fce4ec"
                    radius: 4
                    Layout.fillWidth: true
                    height: 32
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 6
                        Text {
                            text: "\u2714"
                            font.pixelSize: 14
                            color: "#c2185b"
                        }
                        Text {
                            text: "Bạn đã nhận được khuyến mãi 10%"
                            font.pixelSize: 12
                            color: "#c2185b"
                        }
                    }
                }
                Button {
                    text: "Lịch sử đặt phòng"
                    Layout.fillWidth: true
                    onClicked: {
                        profileDialog.close();
                        stackViewRef.push("qrc:/Pkg/MVC/Views/BookingHistory.qml",{
                            stackViewRef: stackViewRef
                        });
                        UserController.getBookingHistory();
                    }
                }
                Button {
                    text: "Đăng xuất"
                    Layout.fillWidth: true
                    onClicked: {
                        UserController.logoutUser();
                    }
                }
            }
        }
    }

    Connections {
        target: UserController
        function onLogoutSuccess() {
            profileDialog.close();
            stackViewRef.replace("Login.qml");
        }
        function onLogoutFailed(errorMsg) {
            console.log("Logout failed: " + errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }
}