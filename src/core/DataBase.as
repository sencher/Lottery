package core {
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import managers.WindowManager;

import utils.Utils;

import vo.AbonementVO;
import vo.ClientVO;
import vo.Time;
import vo.VisitDayVO;

public class DataBase {
    public var base:Array = [];
    private var wm:WindowManager = WindowManager.instance;
    private static var _instance:DataBase;
    private var loading:Boolean;

    public function DataBase() {
        if (_instance) {
            throw new Error("core.DataBase... use instance()");
        }
        _instance = this;
    }

    public static function get instance():DataBase {
        if (!_instance) {
            new DataBase();
        }
        return _instance;
    }

    public function add(client:ClientVO):Boolean {
//        if (!findDuplicates(client)) {
            base.push(client);
            save();
            return true;
//        } else {
//            return false;
//        }
    }


    private function compare(c1:ClientVO, c2:ClientVO):int {
        return c1.cardId - c2.cardId;
    }

    public function save(mode:String = 'all'):void {
        if (loading)
            return;

        try{
            saveStream.position;
            wm.ShowPopup("Ошибка сохранения! Файл занят системой.", true);
            return;
        }catch (e:Error){
        }

        if (!base.length) {
            wm.ShowPopup("Нечего сохранять");
            return;
        }

        if (mode == 'all' || mode == Config.HISTORY) {
            initFile(Config.HISTORY);
            saveStream = new FileStream();
            saveStream.open(file, FileMode.WRITE);
            saveStream.writeUTFBytes(generateHistorySave(base));
            saveStream.close();
            wm.ShowPopup("База сохранена : " + base.length + " клиентов", true);
        }

        //save abonement
        if (mode == 'all' || mode == Config.SESSION) {
            initFile(Config.SESSION);
            saveStream = new FileStream();
            saveStream.open(file, FileMode.WRITE);
//            saveStream.writeUTFBytes(generateSessionSave(base));
            saveStream.close();
        }

//        //save visits
//        if (mode == 'all' || mode == Config.VISITS) {
//            initFile(Config.VISITS);
//            saveStream = new FileStream();
//            saveStream.open(file, FileMode.WRITE);
//            saveStream.writeUTFBytes(VisitManager.instance.generateSave());
//            saveStream.close();
//            //wm.ShowPopup("Сохранено " + VisitManager.instance.base.length + " дневных отчетов", true);
//        }
    }

    private function generateHistorySave(array:Array):String {
        var s:String = Config.getSaveHeader();
        var client:ClientVO;
        for each (client in array) {
            s += client + Config.LINE_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    private function generateSessionSave(vector:Vector.<ClientVO>):String {
        var s:String = Config.getSaveHeader();
        var client:ClientVO;
        for each (client in vector) {
            s += client.abonementString() + Config.LINE_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    private var file:File;
    private var loadStream:FileStream;
    private var saveStream:FileStream;
    private var currentQueueId:int = -1;
    private var loadQueue:Array = [
        [Config.HISTORY, parseHistory],
        [Config.SESSION, parseSession]/*,
        [Config.ABONEMENTS, parseAbonement],
         [Config.CLIENTS, parseClients, Config.MERGE1],
         [Config.VISITS, parseVisits, Config.MERGE1],
         [Config.ABONEMENTS, parseAbonement, Config.MERGE1],
         [Config.CLIENTS, parseClients, Config.MERGE2],
         [Config.VISITS, parseVisits, Config.MERGE2],
         [Config.ABONEMENTS, parseAbonement, Config.MERGE2]*/
    ];

    public function load():void {
        loading = true;
        loadStream = new FileStream();
        loadStream.addEventListener(ProgressEvent.PROGRESS, stream_progressHandler);
//        fileStream.addEventListener(Event.CLOSE, stream_closeHandler);
        loadStream.addEventListener(Event.COMPLETE, stream_completeHandler);
        loadNextFile();
    }

    private function loadNextFile():void {
        currentQueueId++;
        initFile(loadQueue[currentQueueId][0], loadQueue[currentQueueId][2] || '');
        loadStream.openAsync(file, FileMode.UPDATE);
    }

    private function stream_completeHandler(event:Event):void {
        loadStream.close();
        if (currentQueueId < loadQueue.length - 1)
            loadNextFile();
        else
            loading = false;
    }

//    private function stream_closeHandler(event:Event):void {
//        trace("CLOSE");
//    }

    private function stream_progressHandler(event:ProgressEvent):void {
//        trace("PROGRESS client " + event.bytesLoaded + " / " + event.bytesTotal);
        if (event.bytesLoaded < event.bytesTotal) return;
        var str:String = loadStream.readMultiByte(loadStream.bytesAvailable, Config.ENCODING);
        loadQueue[currentQueueId][1](str);
    }

    private function initFile(path:String, customFolder:String = ''):void {
        file = File.applicationStorageDirectory;
        file = file.resolvePath(customFolder + path);
    }

    private function parseHistory(fileStream:String):void {
        var array:Array = fileStream.split(Config.LINE_DELIMITER);
        array.shift();// ignore save header

        var vector:Vector.<ClientVO> = new <ClientVO>[];
        var s:String;
        for each(s in array) {
            if (s.length) {
                var client:ClientVO = new ClientVO(s);
                if(client.cardId < 1){
                    wm.ShowPopup("Неправильный формат клиента! : " + s);
                    continue;
                }
                vector.push(client);
            }
        }

        wm.ShowPopup("История загружена : " + base.length);
    }

    private function parseSession(str:String):void {
//        var arrayAb:Array = str.split(Config.LINE_DELIMITER);
//        arrayAb.shift();// ignore save header
//
//        var s:String;
//        var id:int;
//        for each(s in arrayAb) {
//            if (s.length) {
//                var array:Array = s.split(Config.FIELD_DELIMITER);
//                id = array.shift();
////                var client:ClientVO = getClientById(id);
//                if(!client){
//                    wm.ShowPopup("Ошибка! Есть абонемент, но нет клиетна № " + id);
//                    continue;
//                }
//                var ab:AbonementVO = new AbonementVO();
//                Utils.deSerialize(ab, array);
////                client.abonement = ab;
//                MergeTool.mergeAbonements(client, ab);
//            }
//        }
//        wm.ShowPopup("Абонементов : " + arrayAb.length, true);
    }

    public function addClipboard(a:Array):void {
        //add validate
        var i:int;
        for(i=0; i<a.length; i++){
            base.push(a.shift());
        }
        save();
    }
}
}
