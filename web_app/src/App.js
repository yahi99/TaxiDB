import React from 'react';
import axios from 'axios';
import ChatBody from './components/chatBody/ChatBody';
import apiUrl from 'constants';
import './App.css';

function App() {

  const [clients, setClients] = React.useState(null)

  React.useEffect(() => {
    axios.get("http://192.168.43.83:5000/" +
      "get_all_request_for_specialist/" +
      1).then((resp) => {
        console.log(resp.data);
      });

  }, []);


  return (
    <div className="__main">
      <ChatBody />
    </div>
  )
}

export default App;
