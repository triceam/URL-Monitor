package com.tricedesigns.model
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class NetworkInterfacesModel
	{
		public var interfaces : ArrayCollection = new ArrayCollection();
		public var isSupported : Boolean = true;
		
		public function NetworkInterfacesModel()
		{
		}
	}
}