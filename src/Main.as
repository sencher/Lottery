package {
import core.Config;
import core.DataBase;

import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;

import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.ui.Keyboard;

import managers.WindowManager;

import windows.StartWindow;

[SWF(backgroundColor="0xFAA719", width="1024", height="768")]
public class Main extends Sprite {

    private var wm:WindowManager = WindowManager.instance;
    private var debug:TextField = new TextField();

    public function Main() {
        var c:Clipboard = Clipboard.generalClipboard;
        var r = c.getData(ClipboardFormats.TEXT_FORMAT);
        trace(r);

        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        if (!Config.DEBUG) this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

        DataBase.instance.load();
        addChild(wm);
        wm.ShowWindow(StartWindow);
        addVersion();
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        stage.addEventListener(Event.REMOVED_FROM_STAGE, restoreFocus);
        stage.addEventListener(Event.REMOVED, restoreFocus);

        if (Config.DEBUG) {
            addChild(debug);
        }

        var square:Sprite = new Sprite();
        addChild(square);
        square.graphics.lineStyle(1,0x999900);
        square.graphics.drawRect(-1,-1,1025,769);
        square.graphics.endFill();
    }

    private function restoreFocus(event:Event):void {
        stage.focus = stage;
    }

    private function addVersion():void {
        var v:TextField = new TextField();
        v.text = "Version " + Config.VERSION;
        v.x = stage.stageWidth - v.textWidth - 10;
        v.y = stage.stageHeight - v.textHeight;
        addChild(v);
    }

    private function onKey(event:KeyboardEvent):void {
        var keyCode:uint = event.keyCode;

        if (keyCode == Keyboard.ESCAPE) {
            event.preventDefault();
            if(wm.popupShowed)
                wm.ClosePopup();
//            else if(wm.currentWindow is StartWindow)
//                wm.saveAndExit();
            else
                wm.ShowPrevious();
        }
    }
}
}
