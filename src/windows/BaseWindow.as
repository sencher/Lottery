package windows {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

import managers.WindowManager;

public class BaseWindow extends Sprite {
    protected var view:MovieClip;
    protected var wm:WindowManager;

    function BaseWindow(viewClass:Class) {
        view = new viewClass();
        addChild(view);
        wm = WindowManager.instance;
    }

    public function init(params:Object = null):void {

    }

    public function close():void {
        unInit();
        this.parent.removeChild(this);
    }

    protected function unInit():void {

    }

    protected function onMenu(event:MouseEvent):void {
        wm.ShowWindow(StartWindow);
    }

    public function saveAdditionalParamsOnExit():Object {
        return {};
    }
}
}
