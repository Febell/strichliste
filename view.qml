import QtQuick 2.0
import QtQuick.Controls 2.4

Rectangle {
    id: window
    width: 800
    height: 600
    color: "#184e7d"

    Image {
        width: 100; height: 100
        fillMode: Image.PreserveAspectFit
        source: "images/logo.png"
        anchors.right: parent.right
        anchors.top: parent.top
    }

    
    StackView {
        id: stack
        initialItem: opener
        anchors.fill: parent

        Component {
            id: opener
            Item {

                Button {
                    text: qsTr("Cart")
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    onClicked: {
                        stack.push(page2)
                    }
                }

                Column {
                    id: openerCol
                    width: 200
                    anchors {
                        left: parent.left
                    }

                    Button {
                        text: qsTr("Drinks")
                        onClicked: {
                            stack.push(page1)
                        }
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }

                    Button {
                        text: qsTr("Pauschale")
                        onClicked: {
                            cart.addStuff("Pauschale Mitglied", 1, 3.0)
                        }
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }

                    Button {
                        text: qsTr("Materialspende")
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }

                    Button {
                        text: qsTr("Status")
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }

                }}

        }
        Component {

            id: page1
            Item{
                GridView {
                    anchors.fill: parent

                    cellWidth: 200; cellHeight: 50
                    focus: true
                    model: drinks

                    delegate: Item {
                        width: 200
                        height: 50

                        Rectangle {
                            width: 190;
                            height: 40;
                            color: "lightsteelblue"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Button {
                            anchors.fill: parent
                            
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                id: textName
                                text: name
                            }
                            Text {
                                anchors.left: textName.right
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: price + "€"
                            }
                            onClicked: {
                                // parent.GridView.view.currentIndex = index
                                cart.addStuff(name, 1, price)
                            }
                            
                        }
                    }
                }
                Button {
                    id: btnCheckOut1
                    anchors.bottom: parent.bottom
                    text: "Check out " + cart.total + "€"
                    onClicked: {
                        stack.push(rfidpage)
                        cart.startTransaction()
                    }
                }
                Button {
                    id: btnSwitchToCart
                    anchors.left: btnCheckOut1.right
                    anchors.bottom: parent.bottom
                    text: "Cart"
                    onClicked: {
                        stack.push(page2)
                    }
                }
                Button {
                    id: btnBackToOpener
                    anchors.left: btnSwitchToCart.right
                    anchors.bottom: parent.bottom
                    text: "Back"
                    onClicked: {
                        stack.pop()
                    }
                }
            }}

        Component {
            id: page2
            Item {
                Rectangle {
                    width: 600
                    color: "lightsteelblue"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }

                    GridView {
                        anchors.fill: parent

                        cellWidth: 600; cellHeight: 50
                        focus: true
                        model: cart

                        highlight: Rectangle {
                            width: 600;
                            height: 40;
                            color: "white"
                            anchors {
                                left: parent.left
                                leftMargin: 5
                            }
                        }

                        delegate: Rectangle {
                            width: 590; height: 50
                            color: "transparent"

                            Text {
                                id: textQuant
                                text: quantity
                                width: 50
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                            Text {
                                anchors {
                                    left: textQuant.right
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                                id: textName
                                text: name
                            }

                            Text {
                                anchors {
                                    right: parent.right
                                    rightMargin: 20
                                    verticalCenter: parent.verticalCenter
                                }
                                text: price + "€"
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    parent.GridView.view.currentIndex = index
                                }

                            }
                        }
                    }
                }
                Button {
                    id: btnBack
                    anchors.bottom: parent.bottom
                    text: "Back"
                    onClicked: { stack.pop() }
                }
                Button {
                    id: btnCheckOut2
                    anchors.bottom: parent.bottom
                    anchors.left: btnBack.right
                    text: "Check out " + cart.total + "€"
                    onClicked: {
                        stack.push(rfidpage)
                        cart.startTransaction()
                    }
                }
            }}

        Component {
            id: rfidpage
            Item {
                Timer {
                    id: timer
                }

                function delay(delayTime, cb) {
                    timer.interval = delayTime;
                    timer.repeat = false;
                    timer.triggered.connect(cb);
                    timer.start();
                }
                Connections {
                    target: cart
                    onCleared: {
                        failureText.visible = !cart.success
                        successText.visible = cart.success
                        delay(5000, function(){ stack.pop({item: opener}) })
                    }
                }
                Text {
                    id: tagText
                    text: "Please insert tag"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: tagText.bottom

                    id: successText
                    text: "Success!"
                    visible: false
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: tagText.bottom

                    id: failureText
                    text: "Fehler!"
                    visible: false
                }
                
            }
        }

    }
}
