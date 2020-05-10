/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong

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

#include "subredditobject.h"

#include <QtCore/QUrl>
#include <QtCore/QSharedData>

class SubredditObjectData : public QSharedData
{
public:
    SubredditObjectData() : subscribers(0), activeUsers(0), isNSFW(false), submissionType(SubredditObject::Any) {}

    QString fullname;
    QString displayName;
    QString title;
    QString url;
    QUrl headerImageUrl;
    QUrl iconUrl;
    QUrl bannerBackgroundUrl;
    QString shortDescription;
    QString longDescription;
    int subscribers;
    int activeUsers;
    bool isNSFW;
    bool isSubscribed;
    SubredditObject::SubmissionType submissionType;
    bool isContributor;
    bool isBanned;
    bool isModerator;
    bool isMuted;
    SubredditObject::SubredditType subredditType;
private:
    Q_DISABLE_COPY(SubredditObjectData)
};


SubredditObject::SubredditObject() :
    d(new SubredditObjectData)
{
}

SubredditObject::SubredditObject(const SubredditObject &other) :
    d(other.d)
{
}

SubredditObject &SubredditObject::operator =(const SubredditObject &other)
{
    d = other.d;
    return *this;
}

SubredditObject::~SubredditObject()
{
}

QString SubredditObject::fullname() const
{
    return d->fullname;
}

void SubredditObject::setFullname(const QString &fullname)
{
    d->fullname = fullname;
}

QString SubredditObject::displayName() const
{
    return d->displayName;
}

void SubredditObject::setDisplayName(const QString &displayName)
{
    d->displayName = displayName;
}

QString SubredditObject::title() const
{
    return d->title;
}

void SubredditObject::setTitle(const QString &title)
{
    d->title = title;
}

QString SubredditObject::url() const
{
    return d->url;
}

void SubredditObject::setUrl(const QString &url)
{
    d->url = url;
}

QUrl SubredditObject::headerImageUrl() const
{
    return d->headerImageUrl;
}

void SubredditObject::setHeaderImageUrl(const QUrl &url)
{
    d->headerImageUrl = url;
}

QUrl SubredditObject::iconUrl() const
{
    return d->iconUrl;
}

void SubredditObject::setIconUrl(const QUrl &url)
{
    d->iconUrl = url;
}

QUrl SubredditObject::bannerBackgroundUrl() const
{
    return d->bannerBackgroundUrl;
}

void SubredditObject::setBannerBackgroundUrl(const QUrl &url)
{
    d->bannerBackgroundUrl = url;
}

QString SubredditObject::shortDescription() const
{
    return d->shortDescription;
}

void SubredditObject::setShortDescription(const QString &description)
{
    d->shortDescription = description;
}

QString SubredditObject::longDescription() const
{
    return d->longDescription;
}

void SubredditObject::setLongDescription(const QString &description)
{
    d->longDescription = description;
}

int SubredditObject::subscribers() const
{
    return d->subscribers;
}

void SubredditObject::setSubscribers(int subscribers)
{
    d->subscribers = subscribers;
}

int SubredditObject::activeUsers() const
{
    return d->activeUsers;
}

void SubredditObject::setActiveUsers(int activeUsers)
{
    d->activeUsers = activeUsers;
}

bool SubredditObject::isNSFW() const
{
    return d->isNSFW;
}

void SubredditObject::setNSFW(bool nsfw)
{
    d->isNSFW = nsfw;
}

bool SubredditObject::isSubscribed() const
{
    return d->isSubscribed;
}

void SubredditObject::setSubscribed(bool subscribed)
{
    d->isSubscribed = subscribed;
}

SubredditObject::SubmissionType SubredditObject::submissionType() const
{
    return d->submissionType;
}

void SubredditObject::setSubmissionType(SubmissionType submissionType)
{
    d->submissionType = submissionType;
}

void SubredditObject::setSubmissionType(const QString &submissionTypeString)
{
    if (submissionTypeString == "any")
        d->submissionType = Any;
    else if (submissionTypeString == "link")
        d->submissionType = Link;
    else if (submissionTypeString == "self")
        d->submissionType = Self;
}

bool SubredditObject::isContributor() const
{
    return d->isContributor;
}

void SubredditObject::setContributor(bool contributor)
{
    d->isContributor = contributor;
}

bool SubredditObject::isBanned() const
{
    return d->isBanned;
}

void SubredditObject::setBanned(bool banned)
{
    d->isBanned = banned;
}

bool SubredditObject::isModerator() const
{
    return d->isModerator;
}

void SubredditObject::setModerator(bool moderator)
{
    d->isModerator = moderator;
}

bool SubredditObject::isMuted() const
{
    return d->isMuted;
}

void SubredditObject::setMuted(bool muted)
{
    d->isMuted = muted;
}

SubredditObject::SubredditType SubredditObject::subredditType() const
{
    return d->subredditType;
}

void SubredditObject::setSubredditType(SubredditType subredditType)
{
    d->subredditType = subredditType;
}

void SubredditObject::setSubredditType(const QString &subredditTypeString)
{
    if (subredditTypeString == "public")
        d->subredditType = Public;
    else if (subredditTypeString == "private")
        d->subredditType = Private;
    else if (subredditTypeString == "restricted")
        d->subredditType = Restricted;
    else if (subredditTypeString == "gold_restricted")
        d->subredditType = GoldRestricted;
    else if (subredditTypeString == "archived")
        d->subredditType = Archived;
}
