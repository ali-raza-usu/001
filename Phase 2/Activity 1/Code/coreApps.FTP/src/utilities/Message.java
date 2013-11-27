package utilities;

import java.io.Serializable;
import java.util.UUID;

public class Message implements Serializable {

	private static final long serialVersionUID = 1L;
	private UUID messageId = null;
	private UUID responseId = null;
	//private String version = "0.0";
	private String sender_version = "0.0";
	private String receiver_version = "0.0";

	public Message() {
	}

	public UUID getResponseId() {
		return responseId;
	}

	public void setResponseId(UUID responseId) {
		this.responseId = responseId;
	}

	public UUID getMessageId() {
		return messageId;
	}

	public String toString() {
		return this.getClass().toString();
	}

	public void setMessageId(UUID _msgId) {
		messageId = _msgId;
	}
	
	public String getSender_version() {
		return sender_version;
	}

	public void setSender_version(String sender_version) {
		this.sender_version = sender_version;
	}

	public String getReceiver_version() {
		return receiver_version;
	}

	public void setReceiver_version(String receiver_version) {
		this.receiver_version = receiver_version;
	}

	
}
