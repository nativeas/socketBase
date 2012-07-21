package org.oswxf.net.socket
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import org.oswxf.net.socket.events.SocketDataEvent;
	
	/**
	 * SocketBase 
	 * @author nativeas
	 * 
	 */
	public class SocketBase extends EventDispatcher
	{
		
		public var id:String = '';
		/**
		 * 设定远端地址 
		 * @param $value
		 * 
		 */		
		public function set host($value:String):void
		{
			_host = $value;
		}
		
		private var _host : String;
		
		/**
		 *设定通讯端口 
		 * @param $value
		 * 
		 */		
		public function set port($value:int):void
		{
			_port= $value;
		}
		private var _port : int;
		
		/**
		 * 安全端口 
		 */		
		private var sPort : int;
		
		/**
		 *时间分发器 
		 */		
		private var ed : IEventDispatcher = null;
		
		/**
		 *调试模式 
		 */
		private var _debug : Boolean = false;
		
		/**
		 *发送的字节数 
		 */
		private var sentBytes : int;
		
		/**
		 *接受的字节数 
		 */
		private var receivedBytes : int;
		
		private var rbuffer : Boolean = false;
		
		private var sbuffer : ByteArray = new ByteArray();
		
		private var buffer : ByteArray = new ByteArray();
		
		private var b0 : uint;
		
		private var _socket:Socket = null;
		
		/**
		 * constructor 
		 * @param sPort
		 * @param ed
		 * @param debug 是否调试模式
		 * 
		 */
		public function SocketBase(sPort : int=0,ed : IEventDispatcher = null,debug : Boolean = false)
		{
			this._socket = new Socket();
			this.sPort = sPort;
			this.ed = ed;
			this._debug = debug;
			_socket.addEventListener(Event.CONNECT, connectedHandler);
			_socket.addEventListener(flash.events.ProgressEvent.SOCKET_DATA, dataRecvHandler);
			_socket.addEventListener(flash.events.IOErrorEvent.IO_ERROR, IOErrorHandler);
			_socket.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.addEventListener(Event.CLOSE, closeHandler);
		}
		
	
		
		/**
		 * 连接
		 */ 
		public function connect(host : String , port : int ) : void
		{
			this._host = host;
			this._port = port;
			if(sPort != 0)
			{
				var str : String = "xmlsocket://" + _host + ":" + sPort;
				Security.loadPolicyFile(str);
			}
			if(!_socket)
				_socket = new Socket();
			_socket.connect(_host, _port);
		}
		
		/**
		 * 关闭socket 连接 
		 * 
		 */		
		public function close() : void
		{
			if(_socket &&_socket.connected)
			{
				_socket.close();
			}
		}
		
		/**
		 * 发送二进制数据 
		 * @param ba
		 * 
		 */
		public function send($data : ByteArray) : void
		{
			if(_socket&&_socket.connected)
			{
				_socket.writeBytes($data);
				_socket.flush();
				sentBytes += ($data.length);
			}else {
				sbuffer.writeBytes($data);
			}
		}
		
		
		/////////////////////////////////////////////////////////////
		////Event Handler
		/////////////////////////////////////////////////////////////
		
		private function connectedHandler(event : Event) : void
		{	
			debug('['+_host+':'+_port.toString()+']:连接 socket服务器成功');
			if(ed)
				ed.dispatchEvent(event);
			if(sbuffer.length>0)
			{
				debug('['+_host+':'+_port.toString()+']:发生离线缓冲数据'+sbuffer.length+'bytes');
				this.send(sbuffer);
				sbuffer = new ByteArray();
			}
			
		}
		
		/**
		 * 处理数据接收 
		 * @param $event
		 * 
		 */
		private function dataRecvHandler($event:ProgressEvent =null):void
		{
			if(!_socket.connected)
				return;
			debug($event.toString());
		}
		
		/**
		 * IO错误处理 
		 * @param event
		 * 
		 */
		private function IOErrorHandler(event : IOErrorEvent) : void
		{
			if(ed)
				ed.dispatchEvent(event);
			debug(event.toString());
		}			
		
		/**
		 *  发生 安全错误
		 * @param event
		 * 
		 */
		private function securityErrorHandler(event : SecurityErrorEvent) : void
		{
			if(ed)
				ed.dispatchEvent(event);
			debug(event.toString());
		}	
		
		/**
		 *  断开socket服务器连接 
		 * @param event
		 * 
		 */
		private function closeHandler(event : Event) : void
		{
			if(ed)
				ed.dispatchEvent(event);
			debug(event.toString());
		}
		
		/**
		 * 处理调试信息 
		 * @param $msg
		 * 
		 */		
		internal function debug($msg:String):void
		{
			if(_debug)
				trace($msg);
		}
	}
}