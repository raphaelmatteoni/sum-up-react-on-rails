import React from 'react';
import CameraCapture from './CameraCapture';
import SendText from './SendText';
import { useNavigate } from 'react-router-dom';

function Home() {
  let navigate = useNavigate();

  const handleNavigation = (billId) => {
    navigate(`/bill-details/${billId}`);
  };

  return (
    <div className="m-2 w-full">
      <div className="mb-4">
        <h2 className="text-xl mb-2">Capturar conta com câmera</h2>
        <CameraCapture onSubmit={handleNavigation} />
      </div>
      <div className="my-6">
        <div className="border-t border-gray-300 w-full"></div>
        <span className="text-sm bg-slate-800 px-2 relative bottom-3">ou</span>
      </div>
      <div className="flex flex-col items-center w-full">
        <label htmlFor="send-text" className="text-base m-2">Digite o texto abaixo:</label>
        <SendText onSubmit={handleNavigation} />
      </div>
    </div>
  );
}

export default Home;
