import bb.cascades 1.4
import "../components"

Sheet {
    id: root
    
    property string path: ""
    
    Page {
        
        titleBar: TitleBar {
            title: qsTr("Share") + Retranslate.onLocaleOrLanguageChanged
            
            dismissAction: ActionItem {
                id: cancelAction
                title: qsTr("Cancel") + Retranslate.onLocaleOrLanguageChanged
                
                onTriggered: {
                    root.path = "";
                    root.close();
                }
            }
            
            acceptAction: ActionItem {
                id: doneAction
                title: qsTr("Done") + Retranslate.onLocaleOrLanguageChanged
                enabled: emailsField.text !== ""
                
                onTriggered: {
                    spinner.start();    
                    _qdropbox.error.connect(root.onError);
                    _qdropbox.sharedFolder.connect(root.addMembers);
                    _qdropbox.shareFolder(root.path);
                }
            }
        }
        
        ScrollView {
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                
                layout: DockLayout {}
                
                Container {
                    Container {
                        leftPadding: ui.du(2)
                        topPadding: ui.du(2)
                        rightPadding: ui.du(2)
                        bottomPadding: ui.du(2)
                        
                        Label {
                            text: qsTr("Resource to share:") + Retranslate.onLocaleOrLanguageChanged
                        }
                    }
                    
                    Container {
                        TextField {
                            text: root.path
                            enabled: false
                        }
                    }
                    
                    Container {
                        leftPadding: ui.du(2)
                        topPadding: ui.du(2)
                        rightPadding: ui.du(2)
                        bottomPadding: ui.du(2)
                        
                        Label {
                            text: qsTr("To (use space as delimeter):") + Retranslate.onLocaleOrLanguageChanged
                        }
                    }
                    
                    Container {
                        TextArea {
                            id: emailsField
                            textFormat: TextFormat.Plain
                            hintText: "Ex.: e1@gmail.com e2@gmail.com"
                            
                            
                            onTextChanging: {
                                doneAction.enabled = text.trim() !== ""
                            }
                        }
                    }
                    
                    AccessLevelDropDown {
                        id: accessLevel
                    }
                }
                
                ActivityIndicator {
                    id: spinner
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    minWidth: ui.du(20)
                }
            }
        }
    }
    
    onCreationCompleted: {
        emailsField.requestFocus();
    }
    
    function onError() {
        _qdropbox.error.disconnect(root.onError);
        spinner.stop();
    }
    
    function addMembers(path, sharedFolderId) {
        _qdropbox.sharedFolder.disconnect(root.addMembers);
        _qdropbox.folderMemberAdded.connect(root.folderMemberAdded);
        if (root.path === path) {
            _qdropbox.addFolderMember(sharedFolderId, emailsField.text.trim().split(" "), accessLevel.selectedOption.value);
        }
    }
    
    function folderMemberAdded() {
        _qdropbox.error.disconnect(root.onError);
        _qdropbox.folderMemberAdded.disconnect(root.folderMemberAdded);
        spinner.stop();
        root.close();
    }
}