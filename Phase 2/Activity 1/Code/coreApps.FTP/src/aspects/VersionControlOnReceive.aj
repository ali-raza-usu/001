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

public aspect VersionControlOnReceive {

	private static Logger _logger = Logger
			.getLogger(VersionControlOnReceive.class);

	private pointcut ChannelRead(SocketChannel _channel, ByteBuffer _buffer) :
		call(* SocketChannel+.read(ByteBuffer)) && target(_channel) && args(_buffer);

	int around(SocketChannel _channel, ByteBuffer _buffer) : ChannelRead(_channel, _buffer) {
		
		
		int readBytes = proceed(_channel, _buffer);
		ByteBuffer tempBuf = _buffer.duplicate();
		
		Message msg = convertBufferToMessage(tempBuf);
		if(msg!=null)
		{
		if (readBytes > 0) {
			Object obj = thisJoinPoint.getThis();
			_logger.debug(obj.getClass().getSimpleName() + " read bytes are " + tempBuf.remaining());
			if (obj instanceof FTPClient) {
				_logger.debug("Message version number expected is :  1.0");
				_logger.debug("Message version number received is: "+msg.getVersion());
				
		}
		else if(obj instanceof FTPServer) {
			_logger.debug("Message version number expected is :  0.0");
			_logger.debug("Message version number received is: "+msg.getVersion());
			
			}
		}
		}
		
		return readBytes;
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
