package org.oswxf.net.socket.events
{
	import com.sevencool.wxf.corelib.events.WXFEvent;
	
	import flash.utils.ByteArray;
	
	/**
	 * Socket数据事件
	 * @author dan
	 * 
	 */
	public class SocketDataEvent extends WXFEvent
	{
		public static const DATA_RECV:String ='data_recv';
		public function SocketDataEvent(type:String, data:ByteArray)
		{
			super(type);
			this.data = data;
		}
		
		public function get bytes():ByteArray
		{
			if(this.data is ByteArray)
				return data as ByteArray;
			else
				return null;
		}
	}
}