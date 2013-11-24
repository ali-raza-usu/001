package aspects;


import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

import application.FTPClient;
import application.FTPServer;

import utilities.*;

public aspect VersionControlOnSend {

	Logger _logger = Logger.getLogger(VersionControlOnSend.class);

	private pointcut ChannelWrite(SocketChannel _channel, ByteBuffer _buffer) :
			call(* SocketChannel+.write(ByteBuffer)) && target(_channel) && args(_buffer);

	Object around(SocketChannel _channel, ByteBuffer _buffer) : ChannelWrite(_channel, _buffer){
		
		//ByteBuffer tempBuf = _buffer.duplicate();
		 Message msg = convertBufferToMessage(_buffer);
		_logger.debug("Data in the buffer " + _buffer.remaining());
		Object obj = thisJoinPoint.getThis();
		if (obj instanceof FTPClient) {
				_logger.debug("Message version number is :  "+ msg.getVersion()+" ");
				_logger.debug("Changing version number to 0.0");
				msg.setVersion("0.0");
				_logger.debug("Message version number after change is :  "+ msg.getVersion()+" ");
		}
		else if(obj instanceof FTPServer) {
			_logger.debug("Message version number is :  "+ msg.getVersion()+" ");
			_logger.debug("Changing version number to 1.0");
			msg.setVersion("1.0");
			_logger.debug("Message version number after change is :  "+ msg.getVersion()+" ");
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
