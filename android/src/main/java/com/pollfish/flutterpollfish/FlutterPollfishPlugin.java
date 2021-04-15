package com.pollfish.flutterpollfish;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.pollfish.Pollfish;
import com.pollfish.builder.Params;
import com.pollfish.builder.Platform;
import com.pollfish.builder.Position;
import com.pollfish.callback.PollfishClosedListener;
import com.pollfish.callback.PollfishOpenedListener;
import com.pollfish.callback.PollfishSurveyCompletedListener;
import com.pollfish.callback.PollfishSurveyNotAvailableListener;
import com.pollfish.callback.PollfishSurveyReceivedListener;
import com.pollfish.callback.PollfishUserNotEligibleListener;
import com.pollfish.callback.PollfishUserRejectedSurveyListener;
import com.pollfish.callback.SurveyInfo;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/**
 * FlutterPollfishPlugin
 */
public class FlutterPollfishPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

    public static final String TAG = "FlutterPollfishPlugin";

    private MethodChannel channel;
    private FlutterPluginBinding binding = null;
    private Activity activity = null;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_pollfish");
        channel.setMethodCallHandler(this);
        this.binding = binding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        this.binding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {}

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {}

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    private void initPollfish(final Activity activity,
                              final String apiKey,
                              final int p,
                              final int indPadding,
                              final boolean releaseMode,
                              final boolean rewardMode,
                              final boolean offerwallMode,
                              final String request_uuid) {

        final Position position = Position.values()[p];

        Params.Builder paramsBuilder = new Params.Builder(apiKey)
                .indicatorPosition(position)
                .indicatorPadding(indPadding)
                .pollfishSurveyCompletedListener(new PollfishSurveyCompletedListener() {
                    @Override
                    public void onPollfishSurveyCompleted(@NotNull SurveyInfo surveyInfo) {
                        if (surveyInfo != null) {

                            Log.d(TAG, "onPollfishSurveyCompleted (CPA: " + surveyInfo.getSurveyCPA() + ", IR: " + surveyInfo.getSurveyIR() + ", LOI: " + surveyInfo.getSurveyLOI() + ", SurveyClass: " + surveyInfo.getSurveyClass() + ", RewardName: " + surveyInfo.getRewardName() + ", RewardValue: " + surveyInfo.getRewardValue() + ")");

                            channel.invokeMethod("pollfishSurveyCompleted", surveyInfo.getSurveyCPA() + "," + surveyInfo.getSurveyIR() + "," + surveyInfo.getSurveyLOI() + "," + surveyInfo.getSurveyClass() + "," + surveyInfo.getRewardName() + "," + surveyInfo.getRewardValue());

                        } else {

                            Log.d(TAG, "onPollfishSurveyCompleted");

                            channel.invokeMethod("pollfishSurveyCompleted", "");
                        }
                    }
                })
                .pollfishSurveyReceivedListener(new PollfishSurveyReceivedListener() {
                    @Override
                    public void onPollfishSurveyReceived(@Nullable SurveyInfo surveyInfo) {
                        if (surveyInfo != null) {

                            Log.d(TAG, "onPollfishSurveyReceived (CPA: " + surveyInfo.getSurveyCPA() + ", IR: " + surveyInfo.getSurveyIR() + ", LOI: " + surveyInfo.getSurveyLOI() + ", SurveyClass: " + surveyInfo.getSurveyClass() + ", RewardName: " + surveyInfo.getRewardName() + ", RewardValue: " + surveyInfo.getRewardValue() + ")");

                            channel.invokeMethod("pollfishSurveyReceived", surveyInfo.getSurveyCPA() + "," + surveyInfo.getSurveyIR() + "," + surveyInfo.getSurveyLOI() + "," + surveyInfo.getSurveyClass() + "," + surveyInfo.getRewardName() + "," + surveyInfo.getRewardValue());

                        } else {

                            Log.d(TAG, "onPollfishSurveyReceived");

                            channel.invokeMethod("pollfishSurveyReceived", "");
                        }
                    }
                })
                .pollfishClosedListener(new PollfishClosedListener() {
                    @Override
                    public void onPollfishClosed() {
                        Log.d(TAG, "onPollfishClosed");

                        channel.invokeMethod("pollfishClosed", null);
                    }
                })
                .pollfishOpenedListener(new PollfishOpenedListener() {
                    @Override
                    public void onPollfishOpened() {
                        Log.d(TAG, "onPollfishOpened");

                        channel.invokeMethod("pollfishOpened", null);
                    }
                })
                .pollfishUserNotEligibleListener(new PollfishUserNotEligibleListener() {
                    @Override
                    public void onUserNotEligible() {
                        Log.d(TAG, "onUserNotEligible");

                        channel.invokeMethod("pollfishUserNotEligible", null);
                    }
                })
                .pollfishUserRejectedSurveyListener(new PollfishUserRejectedSurveyListener() {
                    @Override
                    public void onUserRejectedSurvey() {
                        Log.d(TAG, "onUserRejectedSurvey");

                        channel.invokeMethod("pollfishUserRejectedSurvey", null);
                    }
                })
                .pollfishSurveyNotAvailableListener(new PollfishSurveyNotAvailableListener() {
                    @Override
                    public void onPollfishSurveyNotAvailable() {
                        Log.d(TAG, "onPollfishSurveyNotAvailable");

                        channel.invokeMethod("pollfishSurveyNotAvailable", null);
                    }
                })
                .releaseMode(releaseMode)
                .rewardMode(rewardMode)
                .platform(Platform.FLUTTER)
                .offerwallMode(offerwallMode);

        if (request_uuid != null) {
            if (request_uuid.trim().length() > 0) {
                paramsBuilder.requestUUID(request_uuid);
            }
        }

        Pollfish.initWith(activity, paramsBuilder.build());
    }

    private void exctractPollfishParams(Activity activity, MethodCall call, Result result) {

        String api_key = null;

        if (call.argument("api_key") != null) {
            api_key = call.argument("api_key");
        }

        if (api_key == null) {
            result.error("no_api_key", "a null api_key was provided", null);
            return;
        }

        int pollfishPosition = 0;
        int indPadding = 50;
        boolean releaseMode = false;
        boolean rewardMode = false;
        boolean offerwallMode = false;
        String request_uuid = null;

        if (call.argument("pollfishPosition") != null) {
            pollfishPosition = call.argument("pollfishPosition");
        }
        if (call.argument("indPadding") != null) {
            indPadding = call.argument("indPadding");
        }
        if (call.argument("releaseMode") != null) {
            releaseMode = call.argument("releaseMode");
        }
        if (call.argument("rewardMode") != null) {
            rewardMode = call.argument("rewardMode");
        }
        if (call.argument("offerwallMode") != null) {
            offerwallMode = call.argument("offerwallMode");
        }

        if (call.argument("request_uuid") != null) {
            request_uuid = call.argument("request_uuid");
        }

        Log.d(TAG, "api_key: " + api_key);
        Log.d(TAG, "pollfishPosition: " + pollfishPosition);
        Log.d(TAG, "indPadding: " + indPadding);
        Log.d(TAG, "releaseMode: " + releaseMode);
        Log.d(TAG, "rewardMode: " + rewardMode);
        Log.d(TAG, "offerwallMode: " + offerwallMode);
        Log.d(TAG, "request_uuid: " + request_uuid);

        if (binding != null)

        initPollfish(activity, api_key, pollfishPosition, indPadding, releaseMode, rewardMode, offerwallMode, request_uuid);
    }

    @Override
    public void onMethodCall(MethodCall call, @NotNull Result result) {
        switch (call.method) {
            case "init":
                if (activity != null) {
                    Log.d(TAG, "Pollfish init");

                    exctractPollfishParams(activity, call, result);
                }

                break;
            case "show":
                Log.d(TAG, "Pollfish show");
                Pollfish.show();

                break;
            case "hide":
                Log.d(TAG, "Pollfish hide");
                Pollfish.hide();

                break;
        }
    }
}
