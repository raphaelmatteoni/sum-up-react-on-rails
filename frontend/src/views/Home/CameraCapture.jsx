import React, { useRef, useState, useEffect } from 'react';
import Button from '../../components/Button/Button';
import { createBillFromImage } from '../../services/api';

const CameraCapture = ({ onSubmit }) => {
  const videoRef = useRef();
  const [isCameraOn, setIsCameraOn] = useState(false);
  const [processing, setProcessing] = useState(false);
  const [image, setImage] = useState(null);
  const fileInputRef = useRef();

  const startCamera = async () => {
    try {
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        const stream = await navigator.mediaDevices.getUserMedia({ video: true });
        videoRef.current.srcObject = stream;
        setIsCameraOn(true);
      }
    } catch (err) {
      console.error("Erro ao acessar a câmera", err);
      alert("Não foi possível acessar a câmera. Por favor, verifique as permissões.");
    }
  };

  const stopCamera = () => {
    if (videoRef.current && videoRef.current.srcObject) {
      const tracks = videoRef.current.srcObject.getTracks();
      tracks.forEach(track => track.stop());
      videoRef.current.srcObject = null;
      setIsCameraOn(false);
    }
  };

  const handleTakePhoto = async () => {
    if (!videoRef.current) return;

    const canvas = document.createElement('canvas');
    canvas.width = videoRef.current.videoWidth;
    canvas.height = videoRef.current.videoHeight;
    canvas.getContext('2d').drawImage(videoRef.current, 0, 0);

    canvas.toBlob(async (blob) => {
      if (!blob) {
        alert('Erro ao capturar imagem.');
        return;
      }
      
      setImage(URL.createObjectURL(blob));
      await processImage(blob);
    }, 'image/jpeg', 0.95);
  };

  const handleFileUpload = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    if (!file.type.startsWith('image/')) {
      alert('Por favor, selecione um arquivo de imagem.');
      return;
    }

    setImage(URL.createObjectURL(file));
    processImage(file);
  };

  const processImage = async (imageFile) => {
    try {
      setProcessing(true);
      stopCamera();
      
      const formData = new FormData();
      formData.append('image', imageFile);
      
      const data = await createBillFromImage(formData);
      onSubmit(data.id);
    } catch (error) {
      console.error('Erro ao processar imagem:', error);
      alert('Ocorreu um erro ao processar a imagem. Por favor, tente novamente.');
      setProcessing(false);
      setImage(null);
    }
  };

  useEffect(() => {
    return () => {
      stopCamera();
    };
  }, []);

  return (
    <div className="w-full flex flex-col items-center space-y-2">
      {!image && !processing && (
        <>
          <div className="flex justify-between w-full">
            <Button
              className="bg-blue-500 text-white px-3 py-1 rounded-md text-base hover:bg-blue-700"
              onClick={() => isCameraOn ? stopCamera() : startCamera()}
            >
              {isCameraOn ? 'Desativar Câmera' : 'Ativar Câmera'}
            </Button>
            
            <Button
              className="bg-green-500 text-white px-3 py-1 rounded-md text-base hover:bg-green-700"
              onClick={() => fileInputRef.current.click()}
            >
              Enviar Imagem
            </Button>
            <input 
              ref={fileInputRef}
              type="file" 
              accept="image/*"
              className="hidden"
              onChange={handleFileUpload}
            />
          </div>
          
          {isCameraOn && (
            <>
              <div className="relative w-full">
                <video 
                  ref={videoRef} 
                  autoPlay 
                  className="w-full h-auto mt-2 border border-gray-400 rounded"
                ></video>
                <Button
                  className="absolute bottom-2 left-1/2 transform -translate-x-1/2 bg-red-500 hover:bg-red-700"
                  onClick={handleTakePhoto}
                >
                  Capturar
                </Button>
              </div>
            </>
          )}
        </>
      )}

      {image && !processing && (
        <div className="w-full">
          <img src={image} alt="Imagem capturada" className="w-full h-auto mt-2 rounded" />
        </div>
      )}

      {processing && (
        <div className="w-full text-center p-4">
          <p>Processando imagem...</p>
          <div className="loader mt-2 mx-auto w-12 h-12 border-4 border-t-4 border-gray-200 rounded-full animate-spin"></div>
        </div>
      )}
    </div>
  );
};

export default CameraCapture;
