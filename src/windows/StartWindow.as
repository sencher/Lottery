package windows {
import core.Config;

import flash.events.MouseEvent;

import utils.Utils;

public class StartWindow extends BaseWindow {

    public function StartWindow() {
        super(start_window);

        addChild(view);
        Utils.initButton(view.history_button, onHistory);
        Utils.initButton(view.predict_button, onPredict);
        Utils.initButton(view.baskets_button, onBaskets);
        Utils.initButton(view.report_button, onReport);
        Utils.initButton(view.about_button, onAbout);
        Utils.initButton(view.exit_button, onExit);
    }

    private function onHistory(event:MouseEvent):void {
        wm.ShowWindow(HistoryWindow);
    }

    private function onPredict(event:MouseEvent):void {
//        wm.ShowWindow(PredictWindow);
    }

    private function onBaskets(event:MouseEvent):void {
//        wm.ShowWindow(BasketsWindow);
    }

    private function onReport(event:MouseEvent):void {
//        wm.ShowWindow(ReportWindow, VisitManager.instance.getDay(new Date(), true));
    }

    private function onAbout(event:MouseEvent):void {
        wm.ShowPopup("\nFit Assistant v." + Config.VERSION + "\n\ns.senkov@gmail.com");
    }

    private function onExit(event:MouseEvent):void {
        wm.saveAndExit();
    }
}
}
