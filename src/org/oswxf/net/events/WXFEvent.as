package com.sevencool.wxf.corelib.events
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * WXFEvent
	 * 该event 需要作为 项目中所有自定义事件的父类
	 *  
	 * @author nativeas
	 */	
	public class WXFEvent extends Event
	{
		/**
		 * 数据 
		 */
		public var data : * = "default data";

		/**
		 * 信息 
		 */
		public var msg : * = "default msg";
		
		/**
		 * 构造函数 
		 * @param type 事件类型
		 * @param args 不定长参。
		 * 
		 */
		public function WXFEvent(type : String, ... args)
		{
			super(type, true, true);
			if(args)
			{
				this.data = ( args[0] != undefined ) ? args[0] :'default';
				this.msg = ( args[1] != undefined ) ? args[1] :'default' ;
			}
		}
		
		/**
		 * 发布事件， 通过 dispatcher() 定义的dispatcher 分发事件
		 * @return 是否分发成功 
		 * 
		 */
		public function dispatch() : Boolean
		{
			if(dispatcher != null)
				return	dispatcher.dispatchEvent(this);
			else
				return false;
		}
		
		/**
		 * 该方法需要被 override  
		 * @return  取得 dispatch()发布的 默认事件分发器
		 * 
		 */
		protected function get dispatcher() : IEventDispatcher
		{
			return null;
		}
	}
}