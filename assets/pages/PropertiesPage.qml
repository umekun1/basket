import bb.cascades 1.4
import bb.system 1.2
import "../components"

Page {
    id: root
    
    property string tag: ""
    property string name: ""
    property string pathLower: ""
    property string pathDisplay: ""
    property string fileId: ""
    property string sharedFolderId: ""
    property variant sharingInfo: undefined
    property int size: 0
    property string rev: ""
    property string contentHash: ""
    property string clientModified: ""
    property string serverModified: ""
    property variant mediaInfo: undefined
    property int membersCount: 0
    
    signal propertiesDone()
    signal showMembers(string name, string path, string sharedFolderId)
    
    titleBar: TitleBar {
        title: qsTr("Properties") + Retranslate.onLocaleOrLanguageChanged
    }
        
    ScrollView {
        Container {
            id: imageHolder
                
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                background: ui.palette.plain
                preferredHeight: ui.du(26)
                
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    maxWidth: ui.du(22)
                    maxHeight: ui.du(26)
                    background: ui.palette.background
                    
                    margin.topOffset: ui.du(2)
                    
                    Container {
                        horizontalAlignment: HorizontalAlignment.Center
                        maxWidth: ui.du(21)
                        maxHeight: ui.du(20)
                        background: ui.palette.plain
                        
                        margin.leftOffset: ui.du(1)
                        margin.topOffset: ui.du(1)
                        margin.rightOffset: ui.du(1)
                        margin.bottomOffset: ui.du(1)
                        
                        layout: DockLayout {}
                        
                        ImageView {
                            id: preview
                            
                            imageSource: {
                                if (root.isDir()) {
                                    return "asset:///images/ic_folder.png";
                                } else {
                                    var ext = _file.extension(root.name).toLowerCase();
                                    if (_file.isImage(ext)) {
                                        _qdropbox.getThumbnail(root.pathDisplay, "w640h480");
                                        return "asset:///images/ic_doctype_picture.png";
                                    } else if (_file.isVideo(ext)) {
                                        return "asset:///images/ic_doctype_video.png";
                                    } else if (_file.isAudio(ext)) {
                                        return "asset:///images/ic_doctype_music.png";
                                    } else if (_file.isPdf(ext)) {
                                        return "asset:///images/ic_doctype_pdf.png";
                                    } else if (_file.isDoc(ext)) {
                                        return "asset:///images/ic_doctype_doc.png";
                                    } else if (_file.isSpreadSheet(ext)) {
                                        return "asset:///images/ic_doctype_xls.png";
                                    } else if (_file.isPresentation(ext)) {
                                        return "asset:///images/ic_doctype_ppt.png";
                                    } else {
                                        return "asset:///images/ic_doctype_generic.png";
                                    }
                                }
                            }
                            preferredWidth: ui.du(21)
                            preferredHeight: ui.du(20)
                            filterColor: {
                                if (root.isDir()) {
                                    return ui.palette.primary;
                                }
                                return ui.palette.textOnPlain;
                            }
                            opacity: root.isDir() ? 0.25 : 1.0
                            scalingMethod: ScalingMethod.AspectFill
                        }
                        
                        ImageView {
                            id: mainImage
                            visible: false
                            preferredWidth: ui.du(21)
                            preferredHeight: ui.du(20)
                            scalingMethod: ScalingMethod.AspectFill
                        }
                        
                        ImageView {
                            id: opacBackground
                            visible: !root.isDir()
                            imageSource: "asset:///images/opac_bg.png"
                            filterColor: Color.Black
                            opacity: 0.8
                            maxHeight: imageLUH.layoutFrame.height / 2
                            verticalAlignment: VerticalAlignment.Bottom
                        }
                        
                        attachedObjects: [
                            LayoutUpdateHandler {
                                id: imageLUH
                            }
                        ]
                    }  
                }    
            }
            
            Header {
                title: {
                    if (root.isDir()) {
                        return qsTr("Folder properties") + Retranslate.onLocaleOrLanguageChanged
                    }
                    return qsTr("File properties") + Retranslate.onLocaleOrLanguageChanged
                }
            }
            
            PropListItem {
                name: qsTr("Filename") + Retranslate.onLocaleOrLanguageChanged + ":"
                value: root.name
            }
            
            PropListItem {
                visible: !root.isDir()
                name: qsTr("Type") + Retranslate.onLocaleOrLanguageChanged + ":"
                value: _file.extension(root.name).toLowerCase()
            }
            
            PropListItem {
                visible: root.clientModified !== ""
                name: qsTr("Last modified") + Retranslate.onLocaleOrLanguageChanged + ":"
                value: _date.str(root.clientModified);
            }
            
            PropListItem {
                visible: !root.isDir()
                name: qsTr("Size") + Retranslate.onLocaleOrLanguageChanged + ":"
                value: Number(root.size / (1024 * 1024)).toFixed(2) + " " + qsTr("MB") + Retranslate.onLocaleOrLanguageChanged
            }
            
            PropListItem {
                name: qsTr("Placement") + Retranslate.onLocaleOrLanguageChanged + ":"
                value: root.pathDisplay
            }
            
            Header {
                title: qsTr("Members") + Retranslate.onLocaleOrLanguageChanged
                mode: HeaderMode.Interactive
                subtitle: root.membersCount
                visible: root.sharedFolderId !== ""
                
                onClicked: {
                    root.showMembers(root.name, root.pathDisplay, root.sharedFolderId);
                }
            }
            
//            PropListItem {
//                visible: root.publicUrl !== ""
//                name: qsTr("Public URL") + Retranslate.onLocaleOrLanguageChanged + ":"
//                value: root.publicUrl
//            }
            
//            Container {
//                visible: root.publicUrl !== ""
//                horizontalAlignment: HorizontalAlignment.Fill
//                
//                leftPadding: ui.du(1)
//                topPadding: ui.du(1)
//                rightPadding: ui.du(1)
//                bottomPadding: ui.du(1)
//                
//                Button {
//                    horizontalAlignment: HorizontalAlignment.Fill
//                    text: qsTr("Copy link to clipboard") + Retranslate.onLocaleOrLanguageChanged
//                    
//                    onClicked: {
//                        if (_app.copyToClipboard(root.publicUrl)) {
//                            toast.body = qsTr("Copied to clipboard") + Retranslate.onLocaleOrLanguageChanged;
//                            toast.position = SystemUiPosition.MiddleCenter
//                            toast.show();
//                        }
//                    }
//                }
//            }
        }
    }
    
    function cleanUp() {
        _qdropbox.thumbnailLoaded.disconnect(root.thumbnailLoaded);
    }
    
    function isDir() {
        return root.tag === "folder";
    }
    
    function thumbnailLoaded(path, localPath) {
        if (root.pathDisplay === path) {
            preview.visible = false;
            opacBackground.visible = false;
            mainImage.imageSource = "file://" + localPath;
            mainImage.visible = true;
        }
    }
    
    onCreationCompleted: {
        _qdropbox.thumbnailLoaded.connect(root.thumbnailLoaded);
    }
    
    attachedObjects: [
        DateTimePicker {
            id: dateTimePicker
            mode: DateTimePickerMode.Time
            value: root.lastModified
        },
        
        SystemToast {
            id: toast
        }
    ]
}