package states;

import kala.asset.Assets;
import kala.asset.Loader;
import kala.Kala;
import kala.objects.group.Group;
import kala.objects.sprite.Sprite;
import kala.objects.text.Text;
import kala.objects.text.TextAlign;

class Preloader extends GenericGroup {

	var loader:Loader;
	var background:Sprite;
	var text:Text;

	public function new() {
		super();
		
		loader = Assets.loader;
		loader
			.queueFont(Assets.fonts.fontName)
			.queueImage(Assets.images.background_blurName)
			.queueAll()
		.load(process);
	}
	
	override public function destroy(destroyBehaviors:Bool = true):Void {
		super.destroy(true);
		text = null;
		background = null;
	}
	
	function process(data:Dynamic, loadedAsset:AssetLoadingInfo, nextAsset:AssetLoadingInfo):Bool {
		var loadedSize = loader.loadedSize;
		var percent = loader.percent;
		
		if (loadedSize > 0) {
			if (loadedSize == 1) {
				text = new Text("RANDOM TEXT TO GET HEIGHT", data, 30, G.width - 20, RIGHT);
				text.y = G.height - 5 - text.height;
				add(text);
			} else if (loadedSize == 2) {
				background = new Sprite(data);
				add(background, 0);
			}
			
			text.text = "LOADING... " + Std.int(percent * 100) + "%";
		}
		
		if (percent == 1) {
			startGame();
			return true;
		}
		
		return false;
	}
	
	function startGame():Void {
		R.init();
		
		MainMenuState.instance = new MainMenuState();
		UpgradeState.instance = new UpgradeState();
		PlayState.instance = new PlayState();
		
		G.switchState(UpgradeState.instance);
		//G.switchState(PlayState.instance);
		//G.switchState(MainMenuState.instance);
		//G.switchState(new SpringRollSplash());
		
		destroy();
	}
	
}