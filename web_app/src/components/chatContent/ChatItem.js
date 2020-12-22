import React from 'react'
import Avatar from '../chatList/Avatar';

export default function ChatItem({ animationDelay, user, msg, image, dateTime }) {
    return (
        <div
            style={{ animationDelay: `0.8s` }}
            className={`chat__item ${user ? user : ""}`}>
            <div className="chat__item__content">
                <div className="chat__msg">{msg}</div>
                <div className="chat__meta">
                    <span>{dateTime}</span>
                </div>
            </div>
            <Avatar isOnline="active" image={image} />
        </div>
    )
}
