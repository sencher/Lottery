///**
// * Created by SenCheR on 18.07.2015.
// */
//package core {
//import managers.WindowManager;
//
//import utils.Utils;
//
//import vo.AbonementVO;
//import vo.ClientVO;
//import vo.VisitDayVO;
//
//public class MergeTool {
//    public static function mergeClients(add:Vector.<ClientVO>):void {
//        var db:DataBase = DataBase.instance;
//        var mainClient:ClientVO;
//        var addClient:ClientVO;
//        var field:String;
//        var mainValue:*;
//        var addValue:*;
//
//        for each (addClient in add) {
//            mainClient = db.getClientById(addClient.cardId);
//            if (!mainClient) {
//                db.addClient(addClient);
//            } else {
//                for each (field in addClient.fields) {
//                    mainValue = mainClient[field];
//                    addValue = addClient[field];
//                    if (addValue is Date) {
//                        if ((mainValue as Date).getTime() != (addValue as Date).getTime()) {
//                            askClient(addClient.cardId, field, mainValue, addValue);
//                        }
//                    } else if (mainValue != addValue) {
//                        askClient(addClient.cardId, field, mainValue, addValue);
//                    }
//                }
//            }
//        }
//    }
//
//    private static function askClient(cardId:uint, field:String, mainValue:*, addValue:*):void {
//        var s:String = "У клиента " + cardId + " произошло задвоение данных. Заменить \n" + mainValue + " на \n\n" + addValue;
//        WindowManager.instance.showQuestionPopup({
//            message: s,
//            id: cardId,
//            field: field,
//            value: addValue
//        }, okClientCallback);
//    }
//
//    private static function okClientCallback(p:*):void {
//        var client:ClientVO = DataBase.instance.getClientById(p.id);
//        client[p.field] = p.value;
//    }
//
//
//    private static function okAbonementCallback(p:*):void {
//        p.client.abonement[p.field] = p.value;
//    }
//
//    private static const DATE_DIFF_EQUAL:int = 300000;
//
//    public static function mergeAbonements(client:ClientVO, add:AbonementVO):void {
//        var field:String;
//        var main:AbonementVO = client.abonement;
//        var dateDiff:Number;
//
//        if (!main) {
//            main = add;
//        } else {
//            for each(field in add.fields) {
//                if (!add[field]) {
//                    continue;
//                } else if (!main[field]) {
//                    main[field] = add[field];
//                } else if (main[field] is Date) {
////                    trace("DATE ", main[field],"\n",add[field]);
//                    dateDiff = (add[field] as Date).getTime() - (main[field] as Date).getTime();
//                    if (Math.abs(dateDiff) < DATE_DIFF_EQUAL) {
//                        continue;
//                    }
//                    // just created while new ClientVO
//                    if (new Date().getTime() - (main[field] as Date).getTime() < DATE_DIFF_EQUAL) {
//                        main[field] = add[field];
//                    } else {
//                        if (field == 'reg_day') {
//                            if (dateDiff < DATE_DIFF_EQUAL) {
//                                main[field] = add[field];
//                            }
//                        } else if (field == 'last_visit') {
//                            if (dateDiff > DATE_DIFF_EQUAL) {
//                                main[field] = add[field];
//                            }
//                        } else {
//                            askAbonement(client, field, main[field], add[field]);
//                        }
//                    }
//                } else if (main[field] != add[field]) {
//                    askAbonement(client, field, main[field], add[field]);
//                }
//            }
//        }
//    }
//
//    private static function askAbonement(client:ClientVO, field:String, mainValue:*, addValue:*):void {
//        WindowManager.instance.showQuestionPopup({
//            message: Utils.swapTextValues(Texts.MERGE_MESSAGE, [client.cardId, field, mainValue, addValue]),
//            client: client,
//            field: field,
//            value: addValue
//        }, okAbonementCallback);
//    }
//}
//}
