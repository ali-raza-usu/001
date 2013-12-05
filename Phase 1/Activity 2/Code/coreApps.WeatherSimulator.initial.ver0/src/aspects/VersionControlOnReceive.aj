package aspects;


import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SocketChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.sql.rowset.spi.TransactionalWriter;

import org.apache.log4j.Logger;


import simulation.communication.Receiver;
import simulation.communication.Transmitter_8815;

import utilities.Encoder;
import utilities.Message;

public aspect VersionControlOnReceive {

	private static Logger _logger = Logger
			.getLogger(VersionControlOnReceive.class);

	private pointcut ChannelRead(DatagramChannel _channel, ByteBuffer _buffer) :
		call(* DatagramChannel+.receive(ByteBuffer)) && target(_channel) && args(_buffer);

	    SocketAddress around(DatagramChannel _channel, ByteBuffer _buffer) : ChannelRead(_channel, _buffer) {
		
	    ByteBuffer tempBuf = _buffer.duplicate();	
	    SocketAddress readBytes=proceed(_channel, _buffer);
	    
	    Message msg = null;
	    
	    if(tempBuf!=null)
		 msg = convertBufferToMessage(tempBuf);
		
		if(msg!=null)
		{
		if (readBytes !=null ) {
			Object obj = thisJoinPoint.getThis();
			_logger.debug(obj.getClass().getSimpleName() + " read bytes are " + tempBuf.remaining());
			if (obj instanceof Receiver) {
				_logger.debug("Object type is "+ obj.getClass().getSimpleName());
				_logger.debug("Message version number expected is :  1.0");
				_logger.debug("Message version number received is: "+msg.getVersion());
				
		}
		else if(obj instanceof Transmitter_8815) {
			_logger.debug("Object type is "+ obj.getClass().getSimpleName());
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
