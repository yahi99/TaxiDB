import React from 'react';
import axios from 'axios';
import ChatBody from './components/chatBody/ChatBody';
import apiUrl from './constatns';
import './App.css';

function App() {

  const [clients, setClients] = React.useState(null)
  const [data, setData] = React.useState(null)

  React.useEffect(() => {
    axios.get(apiUrl +
      "/get_all_request_for_specialist/" +
      1).then((resp) => {
        setData(resp.data);
      });
  }, []);


  return (
    <div className="__main">
      <ChatBody />
    </div>
  )
}

export default App;
