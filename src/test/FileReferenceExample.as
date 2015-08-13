package test {
import flash.display.Sprite;
import flash.events.*;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.URLRequest;

public class FileReferenceExample extends Sprite {
    private var uploadURL:URLRequest;
    private var file:FileReference;

    public function FileReferenceExample() {
        uploadURL = new URLRequest();
        uploadURL.url = "http://img1.liveinternet.ru/images/attach/c/2/73/84/73084451_4270844_golova_Ioana__siski_i_serdce.jpg";
        file = new FileReference();
        configureListeners(file);
        file.browse(getTypes());
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.CANCEL, cancelHandler);
        dispatcher.addEventListener(Event.COMPLETE, completeHandler);
        dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        dispatcher.addEventListener(Event.OPEN, openHandler);
        dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        dispatcher.addEventListener(Event.SELECT, selectHandler);
        dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
    }

    private function getTypes():Array {
        var allTypes:Array = [getImageTypeFilter(), getTextTypeFilter()];
        return allTypes;
    }

    private function getImageTypeFilter():FileFilter {
        return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
    }

    private function getTextTypeFilter():FileFilter {
        return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
    }

    private function cancelHandler(event:Event):void {
        trace("cancelHandler: " + event);
    }

    private function completeHandler(event:Event):void {
        trace("completeHandler: " + event);
    }

    private function uploadCompleteDataHandler(event:DataEvent):void {
        trace("uploadCompleteData: " + event);
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
        trace("httpStatusHandler: " + event);
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        trace("ioErrorHandler: " + event);
    }

    private function openHandler(event:Event):void {
        trace("openHandler: " + event);
    }

    private function progressHandler(event:ProgressEvent):void {
        var file:FileReference = FileReference(event.target);
        trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        trace("securityErrorHandler: " + event);
    }

    private function selectHandler(event:Event):void {
        var file:FileReference = FileReference(event.target);
        trace("selectHandler: name=" + file.name + " URL=" + uploadURL.url);
        file.upload(uploadURL);
    }
}
}