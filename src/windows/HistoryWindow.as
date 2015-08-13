/**
 * Created by SenCheR on 06.08.2015.
 */
package windows {
import core.DataBase;

import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;

import flash.events.MouseEvent;

import utils.Utils;

public class HistoryWindow extends BackableWindow {
    private const NUM_VALUES:int = 11;
    public function HistoryWindow() {
        super(history_window);
        Utils.initButton(view.clipboard, onClipboard);
        Utils.initButton(view.next, onNext);
        Utils.initButton(view.ok, onOk);
    }

    private function onClipboard(event:MouseEvent):void {
        if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)){
            var text:String = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
            var a = text.split("\r\n");
//            b = text.split("\t");
            var i:int;
            for (i = 0; i < a.length;i++) {
                a[i] = a[i].split("\t");
//                view["n"+i].text = a[i];
            }
            trace(a);
            DataBase.instance.addClipboard(a);
        }
    }

    private function onNext(event:MouseEvent):void {
//        DataBase.instance.addTour(collectValues());
    }

//    private function collectValues():Array {
//        var a:Array = [];
//        for
//    }

    private function onOk(event:MouseEvent):void {}
}
}
