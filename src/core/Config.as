package core {
public class Config {
    public static const HISTORY:String = "history.txt";
    public static const SESSION:String = "session.txt";
    public static const ENCODING:String = "utf-8";
    public static const FIELD_DELIMITER:String = "●";
    public static const LINE_DELIMITER:String = "█";
    public static const DATE_SPECIAL:String = "½";
    public static const VERSION:String = "6.8.15";
    public static const DEBUG:Boolean = true;

    public static var saveVersion:String = "";

    public static function getSaveHeader():String
    {
        var date:Date = new Date();
        return VERSION + FIELD_DELIMITER + date.date + "/" + date.month+1 + "/" + date.fullYear + LINE_DELIMITER;
    }
}
}
