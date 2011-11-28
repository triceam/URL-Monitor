package com.tricedesigns.controller
{
	import com.tricedesigns.model.NetworkInterfacesModel;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import mx.collections.ArrayCollection;

	public class NetworkInterfaceController
	{	
		[Inject]
		public var model : NetworkInterfacesModel;
		
		public function NetworkInterfaceController()
		{	
		}
		
		[PostConstruct]
		public function initialize() : void
		{
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);	
			updateInterfaceDataProvider();
		}
		
		protected function onNetworkChange(event : Event) : void
		{
			updateInterfaceDataProvider();
		}
		
		protected function updateInterfaceDataProvider() : void
		{
			
			if ( NetworkInfo.isSupported ) 
			{
				model.interfaces.disableAutoUpdate();
				model.interfaces.removeAll();
								
				for each ( var ni : NetworkInterface in NetworkInfo.networkInfo.findInterfaces() )
				{
					model.interfaces.addItem( ni );
				}
				model.interfaces.enableAutoUpdate();
			}
			else 
				model.isSupported = false;
		}
	}
}