package utilities.messages.ver1;

import java.io.Serializable;
import java.util.UUID;

import org.junit.Test;

import utilities.Message;


public class WeatherDataRequest extends Message {

	

	private static final long serialVersionUID = 1L;
	private UUID requestId = UUID.randomUUID();

	public WeatherDataRequest() {
		this.setVersion("1.0");
	}

	
	@Test
	public void testRandomType() {
		int i = 0;
		//while (i++ < 20) {
			//System.out.println(randomType().name());
		//}
	}

	public UUID getRequestId() {
		return requestId;
	}

	public void setRequestId(UUID requestId) {
		this.requestId = requestId;
	}

}
