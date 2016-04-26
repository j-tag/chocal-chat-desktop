#ifndef FILEIO_HPP
#define FILEIO_HPP

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QTemporaryDir>
#include <QUrl>
#include <QBuffer>
#include <QImage>
#include <QCryptographicHash>
#include <QUuid>
#include <QDebug>

class FileIO : public QObject
{
	Q_OBJECT

public:
	FileIO();

public slots:
	bool write(const QString& source, const QString& data);
	bool decodeAndWrite(const QString& source, const QString& data);
	bool setUserAvatar(int userLocalId, const QString& data);
	bool hasAvatar(int userLocalId);
	QString getAvatarPath(int userLocalId=-2);
	QUrl getAvatarUrl(int userLocalId);
	QString getImagePath(const QString& name);
	QString decodeImage(const QString& data);
	QString encodeImage(const QString& source);
    QString encodeImage(const QUrl& source);
    QString cropEncodeImage(const QUrl &source);
	QString getFileType(const QString& source);
	int getNewUserLocalId();
	QString getMd5Hash(const QString& data);

protected:
	QTemporaryDir m_tmpAvatarDir;
	QTemporaryDir m_tmpImageDir;
	int m_userIdCounter = 1;
};

#endif // FILEIO_HPP
