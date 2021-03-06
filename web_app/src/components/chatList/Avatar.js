import React from 'react'

export default function Avatar({image}) {
    return (
        <div className="avatar">
            <div className="avatar-img">
                <img src={image} alt="#" />
            </div>
        </div>
    )
}
