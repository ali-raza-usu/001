package utilities.messages.ver0;

import java.util.UUID;

import org.junit.Test;

import utilities.RequestType;


public class WeatherDataRequest extends utilities.Message {

	private RequestType reqType;

	private static final long serialVersionUID = 1L;
	private UUID requestId = UUID.randomUUID();

	public WeatherDataRequest(RequestType _type) {
		this.setVersion("0.0");
		reqType = _type;
	}

	public RequestType getReqType() {
		return reqType;
	}

	public void setReqType(RequestType reqType) {
		this.reqType = reqType;
	}

	private RequestType randomType() {
		RequestType[] _type = RequestType.values();
		int val = 0 + (int) (Math.random() * 3);
		return _type[val];
	}

	@Test
	public void testRandomType() {
		int i = 0;
		while (i++ < 20) {
			System.out.println(randomType().name());
		}
	}

	public UUID getRequestId() {
		return requestId;
	}

	public void setRequestId(UUID requestId) {
		this.requestId = requestId;
	}

}
