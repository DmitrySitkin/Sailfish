import QtQuick 2.0
import Sailfish.Silica 1.0
import custom.Matrix 1.0

Page {
    id: page

    property int x_r: 0;
    property int y_r: 0;
    property int msize: 0
    property int i_: 0;
    property int j_: 0
    property int num_txt: 0
    property variant array: []
    property variant recs: []
    property int degree_: 2
    property int len: 0
    property variant matrices: []
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: 2500

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        TextField {
            id: sizeField
            width: parent.width/1.8
            color: "black"
            anchors.top: parent.top
            placeholderText: "Enter the matrix size"
        }
        Button {
            anchors.left: sizeField.right
            id: sizeButton
            anchors.margins: 10
            width: parent.width/3
            text: "Enter size"
            onClicked: {
                //Matrix a
                //matrices.push()

                if (recs.length != 0) {
                    console.log("rec_length "+recs.length)
                    console.log(m.size)
                    len = recs.length
                    for (var i = 0; i < len; i++) {
                        var rec = recs.pop()
                        var ar = array.pop()
                        rec.destroy()
                        ar.destroy()
                    }
                    m.reload(sizeField.text)
                }
                //m.reload(sizeField.text)
                msize = sizeField.text
                var index = 0;
                for (var i = 0; i < m.size; i++) {
                    j_ = 0;
                    for (var j = 0; j < m.size; j++) {
                        index++;
                        Qt.createQmlObject(root.sc, root, 'obj' + index);
                        Qt.createQmlObject(root2.sc, root2, 'obj' + index);
                        Qt.createQmlObject(root3.sc, root3, 'obj' + index);
                        page.x_r+=160;
                        j_++;
                        page.num_txt++;

                    }

                    i_++;

                    page.x_r -= m.size * 160
                    page.y_r += 160;
                }
                page.y_r -= m.size * 160
                i_ = 0;
                j_ = 0;
                page.num_txt = 0;
            }
        }


        Matrix {
            id: m
            size: msize
        }

        Rectangle {
            id: root
            height: 150*sizeField.text
            width: 150*sizeField.text
            anchors.top: label_A.bottom
            color: "transparent"
            property string sc: 'import QtQuick 2.0; import Sailfish.Silica 1.0;
                        Rectangle {
                            id: rec_' + String(page.num_txt) + '
                            width: 150;
                            height: 150;
                            TextField {
                                id: '+ "txt_"+ String(page.num_txt) +'
                                text: ' + '"' + m.getElement(0,0) + '"' +';
                                height: parent.height;
                                width: parent.width;
                                }
                                color: "white";
                                Component.onCompleted:
                                {x = '+page.x_r+'; y = '+page.y_r+'; array['+ page.num_txt + '] = '+ "txt_"+ String(page.num_txt) +
                                '; recs['+ page.num_txt + '] = '+ "rec_"+ String(page.num_txt) + '}
                        }'
        }
        Label {
                id: label_A
                text: "A:"
                anchors.top: sizeButton.bottom
            }
        Label {
                id: label_B
                text: "B:"
                anchors.top: root.bottom
            }
        Label {
                id: label_C
                text: "C:"
                anchors.top: root2.bottom
            }

        Rectangle {
            id: root2
            height: 150*sizeField.text
            width: 150*sizeField.text
            anchors.top: label_B.bottom
            color: "transparent"
            property string sc: 'import QtQuick 2.0; import Sailfish.Silica 1.0;
                        Rectangle {
                            id: rec_' + String(page.num_txt) + '
                            width: 150;
                            height: 150;
                            TextField {
                                id: '+ "txt_"+ String(page.num_txt) +'
                                text: ' + '"' + m.getElement(0,0) + '"' +';
                                height: parent.height;
                                width: parent.width;
                                }
                                color: "white";
                                Component.onCompleted:
                                {x = '+page.x_r+'; y = '+page.y_r+'; array['+ page.num_txt + '] = '+ "txt_"+ String(page.num_txt) +
                                '; recs['+ page.num_txt + '] = '+ "rec_"+ String(page.num_txt) + '}
                        }'
        }
        Rectangle {
            id: root3
            height: 150*sizeField.text
            width: 150*sizeField.text
            anchors.top: label_C.bottom
            color: "transparent"
            property string sc: 'import QtQuick 2.0; import Sailfish.Silica 1.0;
                        Rectangle {
                            id: rec_' + String(page.num_txt) + '
                            width: 150;
                            height: 150;
                            TextField {
                                id: '+ "txt_"+ String(page.num_txt) +'
                                text: ' + '"' + m.getElement(0,0) + '"' +';
                                height: parent.height;
                                width: parent.width;
                                }
                                color: "white";
                                Component.onCompleted:
                                {x = '+page.x_r+'; y = '+page.y_r+'; array['+ page.num_txt + '] = '+ "txt_"+ String(page.num_txt) +
                                '; recs['+ page.num_txt + '] = '+ "rec_"+ String(page.num_txt) + '}
                        }'
        }
        Button {
            id: pow
            text: "Solve"
            width: parent.width/3
            anchors.top: root3.bottom
            anchors.right: parent.right
            anchors.margins: 10
            onClicked: {
                var index = 0;
                var i;
                var j;
                for (i = 0; i < m.getSize(); i++) {
                    for (j = 0; j < m.getSize(); j++) {
                        m.setElement(String(array[index].text), i, j)
                        index++;
                    }
                }
                m.degree(degree_);
                index = 0
                console.log("Pow...")
                for (i = 0; i < m.getSize(); i++) {
                    for (j = 0; j < m.getSize(); j++) {
                        array[index].text = m.getElement(i, j);
                        index++;
                    }

                }
                console.log("Pow...DONE")
            }
        }
        Rectangle {
            id: result
            height: 150*sizeField.text
            width: 150*sizeField.text
            anchors.top: pow.bottom
            color: "transparent"
            property string sc: 'import QtQuick 2.0; import Sailfish.Silica 1.0;
                        Rectangle {
                            id: rec_' + String(page.num_txt) + '
                            width: 150;
                            height: 150;
                            TextField {
                                id: '+ "txt_"+ String(page.num_txt) +'
                                text: ' + '"' + m.getElement(0,0) + '"' +';
                                height: parent.height;
                                width: parent.width;
                                }
                                color: "white";
                                Component.onCompleted:
                                {x = '+page.x_r+'; y = '+page.y_r+'; array['+ page.num_txt + '] = '+ "txt_"+ String(page.num_txt) +
                                '; recs['+ page.num_txt + '] = '+ "rec_"+ String(page.num_txt) + '}
                        }'
        }
    }
}
