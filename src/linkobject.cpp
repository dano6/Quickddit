/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong
    Copyright (C) 2015-2020  Sander van Grieken

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

#include "linkobject.h"

#include <QtCore/QSharedData>
#include <QtCore/QDateTime>
#include <QtCore/QUrl>

class LinkObjectData : public QSharedData
{
public:
    LinkObjectData() : score(0), likes(0), commentsCount(0), distinguished(LinkObject::NotDistinguished),
        isSticky(false), isNSFW(false), isPromoted(false), crossposts(0) {}

    QString author;
    QDateTime created;
    QString subreddit;
    int score;
    int likes;
    int commentsCount;
    QString title;
    QString domain;
    QUrl thumbnailUrl;
    QUrl previewUrl;
    int previewHeight;
    int previewWidth;
    QString text;
    QString rawText;
    QString permalink;
    QUrl url;
    LinkObject::DistinguishedType distinguished;
    bool isSticky;
    bool isNSFW;
    bool isPromoted;
    QString flairText;
    bool isArchived;
    int gilded;
    bool isLocked;
    int crossposts;
    // int num_reports
    // bool pinned
    // bool spoiler

private:
    Q_DISABLE_COPY(LinkObjectData)
};

LinkObject::LinkObject() : Thing(),
    d(new LinkObjectData)
{
    setKind("t3");
}

LinkObject::LinkObject(const LinkObject &other) : Thing(other),
    d(other.d)
{
}

LinkObject &LinkObject::operator =(const LinkObject &other)
{
    Thing::operator =(other);
    d = other.d;
    return *this;
}

LinkObject::~LinkObject()
{
}

QString LinkObject::author() const
{
    return d->author;
}

void LinkObject::setAuthor(const QString &author)
{
    d->author = author;
}

QDateTime LinkObject::created() const
{
    return d->created;
}

void LinkObject::setCreated(const QDateTime &created)
{
    d->created = created;
}

QString LinkObject::subreddit() const
{
    return d->subreddit;
}

void LinkObject::setSubreddit(const QString &subreddit)
{
    d->subreddit = subreddit;
}

int LinkObject::score() const
{
    return d->score;
}

void LinkObject::setScore(int score)
{
    d->score = score;
}

int LinkObject::likes() const
{
    return d->likes;
}

void LinkObject::setLikes(int likes)
{
    d->likes = likes;
}

int LinkObject::commentsCount() const
{
    return d->commentsCount;
}

void LinkObject::setCommentsCount(int count)
{
    d->commentsCount = count;
}

QString LinkObject::title() const
{
    return d->title;
}

void LinkObject::setTitle(const QString &title)
{
    d->title = title;
}

QString LinkObject::domain() const
{
    return d->domain;
}

void LinkObject::setDomain(const QString &domain)
{
    d->domain = domain;
}

QUrl LinkObject::thumbnailUrl() const
{
    return d->thumbnailUrl;
}

void LinkObject::setThumbnailUrl(const QUrl &url)
{
    d->thumbnailUrl = url;
}

QUrl LinkObject::previewUrl() const
{
    return d->previewUrl;
}

void LinkObject::setPreviewUrl(const QUrl &url)
{
    d->previewUrl = url;
}

int LinkObject::previewHeight() const
{
    return d->previewHeight;
}

void LinkObject::setPreviewHeight(const int url)
{
    d->previewHeight = url;
}

int LinkObject::previewWidth() const
{
    return d->previewWidth;
}

void LinkObject::setPreviewWidth(const int url)
{
    d->previewWidth = url;
}

QString LinkObject::text() const
{
    return d->text;
}

void LinkObject::setText(const QString &text)
{
    d->text = text;
}

QString LinkObject::rawText() const
{
    return d->rawText;
}

void LinkObject::setRawText(const QString &rawText)
{
    d->rawText = rawText;
}

QString LinkObject::permalink() const
{
    return d->permalink;
}

void LinkObject::setPermalink(const QString &permalink)
{
    d->permalink = permalink;
}

QUrl LinkObject::url() const
{
    return d->url;
}

void LinkObject::setUrl(const QUrl &url)
{
    d->url = url;
}

LinkObject::DistinguishedType LinkObject::distinguished() const
{
    return d->distinguished;
}

void LinkObject::setDistinguished(DistinguishedType distinguished)
{
    d->distinguished = distinguished;
}

void LinkObject::setDistinguished(const QString &distinguishedString)
{
    if (distinguishedString.isEmpty())
        d->distinguished = NotDistinguished;
    else if (distinguishedString == "moderator")
        d->distinguished = DistinguishedByModerator;
    else if (distinguishedString == "admin")
        d->distinguished = DistinguishedByAdmin;
    else if (distinguishedString == "special")
        d->distinguished = DistinguishedBySpecial;
}

bool LinkObject::isSticky() const
{
    return d->isSticky;
}

void LinkObject::setSticky(bool isSticky)
{
    d->isSticky = isSticky;
}

bool LinkObject::isNSFW() const
{
    return d->isNSFW;
}

void LinkObject::setNSFW(bool isNSFW)
{
    d->isNSFW = isNSFW;
}

bool LinkObject::isPromoted() const
{
    return d->isPromoted;
}

void LinkObject::setPromoted(bool isPromoted)
{
    d->isPromoted = isPromoted;
}

QString LinkObject::flairText() const
{
    return d->flairText;
}

void LinkObject::setFlairText(const QString &flairText)
{
    d->flairText = flairText;
}

bool LinkObject::isArchived() const
{
    return d->isArchived;
}

void LinkObject::setArchived(bool archived)
{
    d->isArchived = archived;
}

int LinkObject::gilded() const
{
    return d->gilded;
}

void LinkObject::setGilded(int gilded)
{
    d->gilded = gilded;
}

bool LinkObject::isLocked() const
{
    return d->isLocked;
}

void LinkObject::setLocked(bool locked)
{
    d->isLocked = locked;
}

int LinkObject::crossposts() const
{
    return d->crossposts;
}

void LinkObject::setCrossposts(int crossposts)
{
    d->crossposts = crossposts;
}

bool LinkObject::isSelfPost() const
{
    return d->domain.indexOf("self.") == 0;
}

