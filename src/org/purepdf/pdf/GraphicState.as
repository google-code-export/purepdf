package org.purepdf.pdf
{
	import org.purepdf.ObjectHash;

	public class GraphicState extends ObjectHash
	{
		public var size: Number;
		internal var charSpace: Number = 0;
		internal var leading: Number = 0;
		internal var scale: Number = 100;
		internal var wordSpace: Number = 0;
		internal var xTLM: Number = 0;
		internal var yTLM: Number = 0;
		internal var colorDetails: ColorDetails;

		public function GraphicState()
		{
		}

		public static function create( state: GraphicState ): GraphicState
		{
			var g: GraphicState = new GraphicState();
			g.size = state.size;
			g.xTLM = state.xTLM;
			g.yTLM = state.yTLM;
			g.leading = state.leading;
			g.scale = state.scale;
			g.charSpace = state.charSpace;
			g.wordSpace = state.wordSpace;
			g.colorDetails = state.colorDetails;
			return g;
		}
	}
}