import React, { useEffect, useState } from "react";
import axios from "axios";

function App() {
  const [msg, setMsg] = useState("");

  useEffect(() => {
    axios
      .get("http://127.0.0.1:8000/api/hello/")
      .then((res) => setMsg(res.data.message))
      .catch((err) => console.error(err));
  }, []);

  return (
    <div>
      <h1>React + Django Test</h1>
      <p>{msg}</p>
    </div>
  );
}

export default App;
