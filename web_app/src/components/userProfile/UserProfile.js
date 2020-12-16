import React from 'react'
import './userProfile.css'

export default function UserProfile() {
    const toggleInfo = (e) => {
        e.target.parentNode.classList.toggle("open");
    };

    return (
        <div className="main__userprofile">
            <div className="profile__card user__profile__image">
                <div className="profile__image">
                    <img src="https://pbs.twimg.com/profile_images/1116431270697766912/-NfnQHvh_400x400.jpg" />
                </div>
                <h4>Вася Иванов</h4>
                <p>Старший оператор</p>
            </div>
            <div className="profile__card">
                <div className="card__header" onClick={toggleInfo}>
                    <h4>Информация</h4>
                    <i className="fa fa-angle-down"></i>
                </div>
                <div className="card__content">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla
                    ultrices urna a imperdiet egestas. Donec in magna quis ligula
          </div>
            </div>
        </div>
    )
}
