/*
 * QDropbox.hpp
 *
 *  Created on: Nov 25, 2017
 *      Author: doctorrokter
 */

#ifndef QDROPBOX_HPP_
#define QDROPBOX_HPP_

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QList>
#include <QVariantMap>

#include "SharedLink.hpp"
#include "QDropboxFile.hpp"
#include "Account.hpp"
#include "QDropboxSpaceUsage.hpp"
#include "../Logger.hpp"

class QDropbox : public QObject {
    Q_OBJECT
public:
    QDropbox(QObject* parent = 0);
    QDropbox(const QString& accessToken, QObject* parent = 0);
    QDropbox(const QString& appSecret, const QString& appKey, const QString& redirectUri, QObject* parent = 0);
    virtual ~QDropbox();

    const QString& getUrl() const;
    QDropbox& setUrl(const QString& url);

    const int& getVersion() const;
    QDropbox& setVersion(const int& version);

    const QString& getAppSecret() const;
    QDropbox& setAppSecret(const QString& appSecret);

    const QString& getAppKey() const;
    QDropbox& setAppKey(const QString& appKey);

    const QString& getRedirectUri() const;
    QDropbox& setRedirectUri(const QString& redirectUri);

    const QString& getAccessToken() const;
    QDropbox& setAccessToken(const QString& accessToken);

    QString authUrl() const;

    // files
    void listFolder(const QString& path = "", const bool& includeMediaInfo = false, const bool& recursive = false,
                    const bool& includeDeleted = false, const bool& includeHasExplicitSharedMembers = false, const bool& includeMountedFolders = true,
                    const int& limit = 0, SharedLink sharedLink = SharedLink());
    void listFolderContinue(const QString& cursor);
    void createFolder(const QString& path, const bool& autorename = false);
    void deleteFile(const QString& path);

    // users
    void getAccount(const QString& accountId);
    void getCurrentAccount();
    void getSpaceUsage();

Q_SIGNALS:
    void accessTokenChanged(const QString& accessToken);

    // files signals
    void listFolderLoaded(const QString& path, QList<QDropboxFile*>& files, const QString& cursor, const bool& hasMore);
    void listFolderContinueLoaded(QList<QDropboxFile*>& files, const QString& prevCursor, const QString& cursor, const bool& hasMore);
    void folderCreated(QDropboxFile* folder);
    void fileDeleted(QDropboxFile* folder);

    // users signals
    void accountLoaded(Account* account);
    void currentAccountLoaded(Account* account);
    void spaceUsageLoaded(QDropboxSpaceUsage* spaceUsage);

private slots:
    void onError(QNetworkReply::NetworkError e);

    // files slots
    void onListFolderLoaded();
    void onListFolderContinueLoaded();
    void onFolderCreated();
    void onFileDeleted();

    // users slots
    void onAccountLoaded();
    void onCurrentAccountLoaded();
    void onSpaceUsageLoaded();

private:
    static Logger logger;

    QNetworkAccessManager m_network;

    QString m_authUrl;
    QString m_url;
    int m_version;

    QString m_accessToken;
    QString m_appSecret;
    QString m_appKey;
    QString m_redirectUri;

    QString m_fullUrl;

    void init();
    void generateFullUrl();

    QNetworkRequest prepareRequest(const QString& apiMethod);
    QNetworkReply* getReply();
};

#endif /* QDROPBOX_HPP_ */
