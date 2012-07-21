package net.eascn.wxf.corelib.socket
{
	import flash.net.Socket;
	
	public class SocketBase extends Socket
	{
		public function SocketBase(host:String=null, port:int=0)
		{
			super(host, port);
		}
	}
}