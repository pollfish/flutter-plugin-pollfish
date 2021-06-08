package com.pollfish.flutterpollfish;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.pollfish.Pollfish;
import com.pollfish.builder.Params;
import com.pollfish.builder.Platform;
import com.pollfish.builder.Position;
import com.pollfish.builder.UserProperties;
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

import java.util.HashMap;
import java.util.Map;

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
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    private Map<String, Object> getMapFromSurveyInfo(SurveyInfo surveyInfo) {
        if (surveyInfo == null) {
            return null;
        }

        Map<String, Object> payload = new HashMap<>();

        if (surveyInfo.getSurveyCPA() != null) {
            payload.put("surveyCPA", surveyInfo.getSurveyCPA());
        }

        if (surveyInfo.getSurveyLOI() != null) {
            payload.put("surveyLOI", surveyInfo.getSurveyLOI());
        }

        if (surveyInfo.getSurveyIR() != null) {
            payload.put("surveyIR", surveyInfo.getSurveyIR());
        }

        if (surveyInfo.getSurveyClass() != null) {
            payload.put("surveyClass", surveyInfo.getSurveyClass());
        }

        if (surveyInfo.getRewardName() != null) {
            payload.put("rewardName", surveyInfo.getRewardName());
        }

        if (surveyInfo.getRewardValue() != null) {
            payload.put("rewardValue", surveyInfo.getRewardValue());
        }

        if (surveyInfo.getRemainingCompletes() != null) {
            payload.put("remainingCompletes", surveyInfo.getRemainingCompletes());
        }

        return payload;
    }

    private void initPollfish(final Activity activity,
                              final String apiKey,
                              final int indicatorPosition,
                              final int indicatorPadding,
                              final boolean releaseMode,
                              final boolean rewardMode,
                              final boolean offerwallMode,
                              final String requestUUID,
                              Map<String, Object> userProperties) {

        final Position position = Position.values()[indicatorPosition];

        Params.Builder paramsBuilder = new Params.Builder(apiKey)
                .indicatorPosition(position)
                .indicatorPadding(indicatorPadding)
                .pollfishSurveyCompletedListener(new PollfishSurveyCompletedListener() {
                    @Override
                    public void onPollfishSurveyCompleted(@NotNull SurveyInfo surveyInfo) {
                        channel.invokeMethod("pollfishSurveyCompleted", getMapFromSurveyInfo(surveyInfo));
                    }
                })
                .pollfishSurveyReceivedListener(new PollfishSurveyReceivedListener() {
                    @Override
                    public void onPollfishSurveyReceived(@Nullable SurveyInfo surveyInfo) {
                        channel.invokeMethod("pollfishSurveyReceived", getMapFromSurveyInfo(surveyInfo));
                    }
                })
                .pollfishClosedListener(new PollfishClosedListener() {
                    @Override
                    public void onPollfishClosed() {
                        channel.invokeMethod("pollfishClosed", null);
                    }
                })
                .pollfishOpenedListener(new PollfishOpenedListener() {
                    @Override
                    public void onPollfishOpened() {
                        channel.invokeMethod("pollfishOpened", null);
                    }
                })
                .pollfishUserNotEligibleListener(new PollfishUserNotEligibleListener() {
                    @Override
                    public void onUserNotEligible() {
                        channel.invokeMethod("pollfishUserNotEligible", null);
                    }
                })
                .pollfishUserRejectedSurveyListener(new PollfishUserRejectedSurveyListener() {
                    @Override
                    public void onUserRejectedSurvey() {
                        channel.invokeMethod("pollfishUserRejectedSurvey", null);
                    }
                })
                .pollfishSurveyNotAvailableListener(new PollfishSurveyNotAvailableListener() {
                    @Override
                    public void onPollfishSurveyNotAvailable() {
                        channel.invokeMethod("pollfishSurveyNotAvailable", null);
                    }
                })
                .releaseMode(releaseMode)
                .rewardMode(rewardMode)
                .platform(Platform.FLUTTER)
                .offerwallMode(offerwallMode);

        if (userProperties != null && !userProperties.isEmpty()) {
            UserProperties.Builder userPropertiesBuilder = new UserProperties.Builder();

            for (String s : userProperties.keySet()) {
                if (userProperties.get(s) != null && userProperties.get(s) instanceof String) {
                    userPropertiesBuilder.customAttribute(s, (String) userProperties.get(s));
                }
            }

            paramsBuilder.userProperties(userPropertiesBuilder.build());
        }

        if (requestUUID != null) {
            if (requestUUID.trim().length() > 0) {
                paramsBuilder.requestUUID(requestUUID);
            }
        }

        Pollfish.initWith(activity, paramsBuilder.build());
    }

    private void exctractPollfishParams(Activity activity, MethodCall call, Result result) {
        String apiKey = null;

        if (call.argument("apiKey") != null) {
            apiKey = call.argument("apiKey");
        }

        if (apiKey == null) {
            result.error("no_api_key", "a null apiKey was provided", null);
            return;
        }

        int pollfishPosition = 0;
        int indicatorPadding = 50;
        boolean releaseMode = false;
        boolean rewardMode = false;
        boolean offerwallMode = false;
        String requestUUID = null;
        Map<String, Object> userProperties = null;

        if (call.argument("indicatorPosition") != null) {
            pollfishPosition = call.argument("indicatorPosition");
        }

        if (call.argument("indicatorPadding") != null) {
            indicatorPadding = call.argument("indicatorPadding");
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

        if (call.argument("requestUUID") != null) {
            requestUUID = call.argument("requestUUID");
        }

        if (call.argument("userProperties") != null) {
            userProperties = call.argument("userProperties");
        }

        if (binding != null)
            initPollfish(activity, apiKey, pollfishPosition, indicatorPadding, releaseMode, rewardMode, offerwallMode, requestUUID, userProperties);

        result.success(null);
    }

    @Override
    public void onMethodCall(MethodCall call, @NotNull Result result) {
        switch (call.method) {
            case "init":
                if (activity != null) {
                    exctractPollfishParams(activity, call, result);
                }
                break;
            case "show":
                Pollfish.show();
                break;
            case "hide":
                Pollfish.hide();
                break;
            case "isPollfishPresent":
                result.success(Pollfish.isPollfishPresent());
                break;
            case "isPollfishPanelOpen":
                result.success(Pollfish.isPollfishPanelOpen());
                break;
            default:
                result.notImplemented();
        }
    }
}
