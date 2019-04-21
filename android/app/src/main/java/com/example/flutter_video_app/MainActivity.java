package com.example.flutter_video_app;

import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;

import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "video_cut_plugin";
    private static final String METHOD = "cutVideo";
    private static final String SRC = "source";
    private static final String DEST = "dest";
    private static final String FROM = "from";
    private static final String TO = "to";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals(METHOD)) {
                        String source = call.argument(SRC);
                        String dest = call.argument(DEST);
                        Integer from = call.argument(FROM);
                        Integer to = call.argument(TO);
                        new TrimVideoTask(result, source, dest, from, to).execute();
                    }
                });
    }

    private static final class TrimVideoTask extends AsyncTask<Void, Void, Integer> {

        private final MethodChannel.Result result;
        private final String source;
        private final String dest;
        private final int from;
        private final int to;

        private TrimVideoTask(MethodChannel.Result result, String source, String dest, int from, int to) {
            this.result = result;
            this.source = source;
            this.dest = dest;
            this.from = from;
            this.to = to;
        }

        @Override
        protected Integer doInBackground(Void... voids) {
            try {
                File sourceFile = new File(source);
                File destFile = new File(dest);
                TrimVideoUtils.startTrim(sourceFile, destFile, from, to);
            } catch (Exception e) {
                Log.e(CHANNEL, "Trim error", e);
                return 2;
            }
            return 1;
        }

        @Override
        protected void onPostExecute(Integer integer) {
            result.success(integer);
        }
    }
}
