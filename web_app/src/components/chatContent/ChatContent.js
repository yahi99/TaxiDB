import React from 'react';
import Avatar from '../chatList/Avatar';
import ChatItem from './ChatItem';
import "./chatContent.css";

export default function ChatContent() {
    const chatItms = [
        {
            key: 1,
            image:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTA78Na63ws7B7EAWYgTr9BxhX_Z8oLa1nvOA&usqp=CAU",
            type: "other",
            msg: "I am fine.",
        },
    ];

    const divRref = React.useRef(null);
    const [state, setState] = React.useState({ chat: chatItms, msg: "" });

    React.useEffect(() => {
        divRref.current.scrollIntoView({ behavior: 'smooth' });
    });

    const handleKeyDown = (e) => {
        if (e.key === 'Enter') {
            if (state.msg !== "") {
                chatItms.push({
                    key: 1,
                    type: "",
                    msg: state.msg,
                    image:
                        "https://pbs.twimg.com/profile_images/1116431270697766912/-NfnQHvh_400x400.jpg",
                });
                setState({ chat: [...chatItms]});
            }
        }
    }

    const onStateChange = (e) => {
        let newState = state;
        newState.msg = e.target.value;
        setState(newState);
    }


    return (
        <div className="main__chatcontent">
            <div className="content__header">
                <div className="blocks">
                    <div className="current-chatting-user">
                        <Avatar
                            isOnline="active"
                            image="https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTA78Na63ws7B7EAWYgTr9BxhX_Z8oLa1nvOA&usqp=CAU"
                        />
                        <p>Петров Петя</p>
                    </div>
                </div>
            </div>

            <div className="content__body">
                <div className="chat__items">
                    {state && state.chat.map((itm, index) => {
                        return (
                            <ChatItem
                                animationDelay={index + 2}
                                key={index}
                                user={itm.type ? itm.type : "me"}
                                msg={itm.msg}
                                image={itm.image}
                                dateTime="17.12.2020 14:47"
                            />
                        );
                    })}
                    <div ref={divRref} />
                </div>
            </div>

            <div className="content__footer">
                <div className="sendNewMessage">
                    <button className="addFiles">
                        <i className="fa fa-plus"></i>
                    </button>
                    <input
                        type="text"
                        placeholder="Введите сообщение"
                        onChange={onStateChange}
                        onKeyDown={handleKeyDown}
                    />
                    <button className="btnSendMsg" id="sendMsgBtn">
                        <i className="fa fa-paper-plane"></i>
                    </button>
                </div>
            </div>

        </div>
    )
}
