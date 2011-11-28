package com.tricedesigns.view.monitor
{
	import com.tricedesigns.controller.URLMonitorController;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.IconItemRenderer;
	
	public class URLMonitorRenderer extends IconItemRenderer
	{
		public function URLMonitorRenderer()
		{
			super();
			this.labelField = "url";
			this.messageField = "lastUpdate";
			this.iconWidth = 64;
			this.iconHeight = 64;
			this.iconFunction = iconValidFunction;
		}
		
		
		[Embed(source="assets/images/valid.png")]
		public static var validImageClass:Class;
		
		[Embed(source="assets/images/invalid.png")]
		public static var invalidImageClass:Class;
		
		[Inject]
		public var controller : URLMonitorController;
		
		private var viewButton : Button;
		private var removeButton : Button;
		
		override protected function createChildren():void
		{
			super.createChildren();
			viewButton = new Button();
			viewButton.label = "View";
			viewButton.height = 25;
			viewButton.y = 10;
			viewButton.visible = true;
			viewButton.setStyle( "padding-left", 0 );
			viewButton.setStyle( "padding-right", 0 );
			viewButton.setStyle( "padding-top", 0 );
			viewButton.setStyle( "padding-bottom", 0 );
			viewButton.addEventListener(MouseEvent.CLICK,onViewClick);
			this.addChild( viewButton );
			
			removeButton = new Button();
			removeButton.label = "Remove";
			removeButton.width = 60;
			removeButton.height = 25;
			removeButton.y = 45;
			removeButton.visible = true;
			removeButton.setStyle( "paddingLeft", 0 );
			removeButton.setStyle( "paddingRight", 0 );
			removeButton.setStyle( "paddingTop", 0 );
			removeButton.setStyle( "paddingBottom", 0 );
			removeButton.addEventListener(MouseEvent.CLICK,onRemoveClick);
			this.addChild( removeButton );
		}
		
		private function onViewClick( event : Event ) : void
		{
			controller.navigateWebView( data.url.toString() );
		}
		
		private function onRemoveClick( event : Event ) : void
		{
			controller.navigateWebView( data.url.toString() );
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w,h);
			var target : Number = w-(viewButton.width+10);
			if ( target != viewButton.x )
				viewButton.x = target;
			
			target = w-(removeButton.width+10);
			if ( target != removeButton.x )
				removeButton.x = target;
		}
		
		private function iconValidFunction(item:Object):Object
		{
			if ( item.online )
				return validImageClass;
			return invalidImageClass;
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			with ( this.graphics )
			{
				clear();
				beginFill( 0xFFFFFF, 1 );
				lineStyle(0,0,0);
				drawRect( 0,1,unscaledWidth,unscaledHeight );
				endFill();
				lineStyle(1,0xDDDDDD,1);
				moveTo( 0,unscaledHeight );
				lineTo( unscaledWidth,unscaledHeight );
			}
		}
	}
}