import React from 'react';
import Avatar from './Avatar';

export default function ChatListItem({ name,
    animationDelay,
    image,
    dateCreate }) {

    const selectChat = (e) => {
        for (
            let index = 0;
            index < e.currentTarget.parentNode.children.length;
            index++
        ) {
            e.currentTarget.parentNode.children[index].classList.remove("active");
        }
        e.currentTarget.classList.add("active");
    }


    return (
        <div
            style={{ animationDelay: `0.${animationDelay}s` }}
            onClick={selectChat}
            className={`chatlist__item`}
        >
            <Avatar
                image={
                    image ? image : "http://placehold.it/80x80"
                }
            />

            <div className="userMeta">
                <p>{name}</p>
                <span className="activeTime">{dateCreate}</span>
            </div>
        </div>
    )
}
