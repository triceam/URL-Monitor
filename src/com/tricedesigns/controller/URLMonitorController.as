package com.tricedesigns.controller
{
	import com.tricedesigns.event.StageWebPreviewEvent;
	import com.tricedesigns.event.URLMonitorEvent;
	import com.tricedesigns.model.URLEntry;
	import com.tricedesigns.model.URLMonitorModel;
	
	import flash.desktop.NativeApplication;
	import flash.events.DNSResolverEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.dns.AAAARecord;
	import flash.net.dns.ARecord;
	import flash.net.dns.DNSResolver;
	import flash.net.dns.MXRecord;
	import flash.net.dns.PTRRecord;
	import flash.net.dns.SRVRecord;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.tlf_internal;
	
	import mx.utils.StringUtil;

	public class URLMonitorController
	{
		[Dispatcher]
		public var dispatcher : IEventDispatcher;
		
		[Inject]
		public var model : URLMonitorModel;
		
		private static const urlRegEx:RegExp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
		
		public function URLMonitorController()
		{
		}
		
		[PostConstruct]
		public function initialize() : void
		{
			restore();
			if(Capabilities.cpuArchitecture=="ARM")
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
			}
		}
		
		private function handleActivate(event:Event):void
		{
			resumeMonitoring();
		}
		
		private function handleDeactivate(event:Event):void
		{
			pauseMonitoring();
		}
		
		
		public function addURL( url : String, save : Boolean = true ) : void
		{
			url = StringUtil.trim( url );
			
			if( url.search( "http" ) != 0 )
				url = "http://" + url;
			
			for each ( var entry : URLEntry in model.urls )
			{
				if ( entry.url == url )
				{
					dispatcher.dispatchEvent( new URLMonitorEvent( URLMonitorEvent.URL_MONITOR_ADD_FAIL, "Endpoint already exists" ) );
					return;
				}
			}
			
			if ( urlRegEx.test( url ) )
			{
				model.urls.addItem( new URLEntry( url ) );
				dispatcher.dispatchEvent( new URLMonitorEvent( URLMonitorEvent.URL_MONITOR_ADD_SUCCESS ) );
			}
			else
				dispatcher.dispatchEvent( new URLMonitorEvent( URLMonitorEvent.URL_MONITOR_ADD_FAIL, "Error: Invalid URL" ) );
			
			if ( save )
				persist();
		}
		
		public function navigateWebView( url : String ) : void
		{
			url = StringUtil.trim( url );
			if ( url.length > 0 )
				dispatcher.dispatchEvent( new StageWebPreviewEvent( url ) );
		}
		
		public function removeURL( entry : URLEntry ) : void
		{
			var index : Number = model.urls.getItemIndex( entry );
			if ( index >= 0 )
			{
				model.urls.removeItemAt( index );
				entry.dispose();
			}
			persist();
		}
		
		protected function restore() : void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("entries.xml");
			var fileStream:FileStream = new FileStream();
			var xml : XML;
			if ( file.exists ) 
			{
				fileStream.open(file, FileMode.READ);
				xml = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();
			}
			else
			{
				xml = new XML( "<entries />" );
			}
			
			model.urls.disableAutoUpdate();
			for each (var entry : XML in xml.entry )
			{
				addURL( entry.value.toString(), false );
			}
			model.urls.enableAutoUpdate();
		}
		
		protected function persist() : void
		{
			var xml :XML = new XML( "<entries />" );
			for each (var entry : URLEntry in model.urls )
			{
				var node : XML = new XML( "<entry/>" );
				node.value = entry.url.toString();
				xml.appendChild( node );
			}
			
			var file:File = File.applicationStorageDirectory.resolvePath("entries.xml");
			var fileStream:FileStream = new FileStream();
			fileStream.open( file, FileMode.WRITE );
			fileStream.writeUTFBytes( xml.toXMLString() );
			fileStream.close();
		}
		
		public function pauseMonitoring() : void
		{
			for each (var entry : URLEntry in model.urls )
			{
				entry.pause();
			}
		}
		
		public function resumeMonitoring() : void
		{
			for each (var entry : URLEntry in model.urls )
			{
				entry.resume();
			}
		}
	}
}