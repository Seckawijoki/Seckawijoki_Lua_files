function printVariableParameter(...)
    local arguments = {...}
    -- if #arguments %2 == 1 then 
    --     arguments[#arguments+1] = ""
    -- end
    if #arguments %2 == 1 then 
        arguments[#arguments] = nil
    end
    print("length = " ..  #arguments)
    for k, v in pairs(arguments) do 
        print(k,v)
    end
end

KEY_LINE_PACKAGE = "package"
KEY_LINE_IMPORT_ANDROID_UTIL_LOG = "import android.util.Log;\n"
KEY_LINE_IMPORT_CREASH_REPORT = "import com.tencent.bugly.crashreport.CrashReport;\n"
KEY_LINE_SUPER_ONCREATE = "super.onCreate()"
KEY_LINE_INIT_CRASH_REPORT = 
[[
        try {
            CrashReport.initCrashReport(getApplicationContext());
        } catch (Exception e) { 
            Log.e("AppPlayApplication", "Bugly SDK missing jar or so", e);
        }
]]

printVariableParameter(
    KEY_LINE_PACKAGE,
    KEY_LINE_IMPORT_ANDROID_UTIL_LOG,
    KEY_LINE_PACKAGE,
    KEY_LINE_IMPORT_CREASH_REPORT,
    KEY_LINE_SUPER_ONCREATE
    -- ,
    -- KEY_LINE_INIT_CRASH_REPORT
)