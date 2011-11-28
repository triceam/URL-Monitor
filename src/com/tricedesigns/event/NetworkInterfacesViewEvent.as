package com.tricedesigns.event
{
	import flash.events.Event;
	
	public class NetworkInterfacesViewEvent extends Event
	{
		public static const NAVIGATE_INTERFACES_VIEW : String = "NAVIGATE_NetworkInterfacesView"
		
		public function NetworkInterfacesViewEvent()
		{
			super(NAVIGATE_INTERFACES_VIEW);
		}
	}
}