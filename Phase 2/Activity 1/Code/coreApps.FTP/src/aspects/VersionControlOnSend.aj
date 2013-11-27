package aspects;


import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

import com.sun.corba.se.impl.javax.rmi.CORBA.Util;

import application.FTPClient;
import application.FTPServer;

import utilities.*;
import utilities.messages.ver0.FileTransferRequest;
import utilities.messages.ver0.FileTransferResponse;

public aspect VersionControlOnSend {

	Logger _logger = Logger.getLogger(VersionControlOnSend.class);

	private pointcut ChannelWrite(SocketChannel _channel, ByteBuffer _buffer) :
			call(* SocketChannel+.write(ByteBuffer)) && target(_channel) && args(_buffer);

	Object around(SocketChannel _channel, ByteBuffer _buffer) : ChannelWrite(_channel, _buffer){
		
		//ByteBuffer tempBuf = _buffer.duplicate();
		 Message msg = convertBufferToMessage(_buffer);
		_logger.debug("Data in the buffer " + _buffer.remaining());
		Object obj = thisJoinPoint.getThis();
		String msgName = msg.getClass().getSimpleName();
		if(msgName!=null)
		{
			if(msgName.equals(FileTransferRequest.class.getSimpleName()))
			{
				if(msg.getSender_version().equals("0.0"))
				{
						
					if(msg.getReceiver_version().equals("1.0"))
					{						
						utilities.messages.ver0.FileTransferRequest req = (utilities.messages.ver0.FileTransferRequest)msg;
						utilities.messages.ver1.FileTransferRequest request=new utilities.messages.ver1.FileTransferRequest(req.getFileIndex(),req.getFileNames());
						msg  = request;
					}
				}
				if(msg.getSender_version().equals("1.0"))
				{
						if(msg.getReceiver_version().equals("0.0"))					
						{
							utilities.messages.ver1.FileTransferRequest req = (utilities.messages.ver1.FileTransferRequest)msg;
							utilities.messages.ver0.FileTransferRequest request=new FileTransferRequest(req.getFileIndex(),req.getFileNames());
							msg  = request;
						}
						
				}
			}
			if(msgName.equals(FileTransferResponse.class.getSimpleName()))
			{
				if(msg.getSender_version().equals("0.0"))
				{
						
					if(msg.getReceiver_version().equals("1.0"))
					{						
						utilities.messages.ver0.FileTransferResponse res = (utilities.messages.ver0.FileTransferResponse)msg;
						utilities.messages.ver1.FileTransferResponse response=new utilities.messages.ver1.FileTransferResponse(res.getFileName(),res.getChunkBytes(), res.isComplete());
						msg  = response;
					}
				}
				if(msg.getSender_version().equals("1.0"))
				{
						if(msg.getReceiver_version().equals("0.0"))					
						{
							utilities.messages.ver1.FileTransferResponse res = (utilities.messages.ver1.FileTransferResponse)msg;
							utilities.messages.ver0.FileTransferResponse response=new FileTransferResponse(res.getFileName(),res.getChunkBytes());
							msg  = response;
						}
						
				}
			}
		}
	
		_buffer = ByteBuffer.wrap(Encoder.encode(msg));
		_logger.debug(obj.getClass().getSimpleName() +  "sending bytes are " + _buffer.remaining());
		return proceed(_channel, _buffer);
	}

	private Message convertBufferToMessage(ByteBuffer buffer) {
		Message message = null;
		byte[] bytes = new byte[buffer.remaining()];
		buffer.get(bytes);
		message = Encoder.decode(bytes);
		buffer.clear();
		buffer = ByteBuffer.wrap(Encoder.encode(message));
		return message;
	}
	
	

}
